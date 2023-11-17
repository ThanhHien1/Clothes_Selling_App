package com.example.PBL6.controller;

import com.example.PBL6.configuration.VNPayConfig;
import com.example.PBL6.dto.cart.CartItemDetail;
import com.example.PBL6.dto.order.OrderDto;
import com.example.PBL6.dto.payment.PaymentCreateDto;
import com.example.PBL6.dto.payment.PaymentResultDto;
import com.example.PBL6.dto.product.FaProductRespDto;
import com.example.PBL6.persistance.cart.CartItem;
import com.example.PBL6.persistance.order.Order;
import com.example.PBL6.persistance.order.OrderItem;
import com.example.PBL6.persistance.product.ProductVariant;
import com.example.PBL6.persistance.user.User;
import com.example.PBL6.repository.OrderItemRepository;
import com.example.PBL6.repository.OrderRepository;
import com.example.PBL6.repository.ProductVariantRepository;
import com.example.PBL6.service.CartService;
import com.example.PBL6.service.OrderService;
import com.example.PBL6.util.AuthenticationUtils;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/payment")
public class PaymentController {
    @Autowired
    private OrderService orderService;

    private User user;

    @GetMapping("/createPayment")
    public ResponseEntity<Object> createPayment(HttpServletRequest request, @Param("amount") double amount) throws UnsupportedEncodingException {
        user = AuthenticationUtils.getUserFromSecurityContext();
        if (user != null) {
            System.out.println("1: " + amount);
            long amountAsLong = (long) (amount * 100);
            System.out.println("2: " + amountAsLong);
            String vnp_TxnRef = VNPayConfig.getRandomNumber(8);

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", VNPayConfig.vnp_Version);
            vnp_Params.put("vnp_Command", VNPayConfig.vnp_Command);
            vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amountAsLong));
            vnp_Params.put("vnp_CurrCode", VNPayConfig.moneyUnit);
            vnp_Params.put("vnp_BankCode", VNPayConfig.bank);

            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", VNPayConfig.orderType);
            vnp_Params.put("vnp_Locale", VNPayConfig.locale);

            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", VNPayConfig.ipAddress);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnp_Params.get(fieldName);
                if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                    //Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    //Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;
            vnp_Params.put("redirect_url", paymentUrl);
//            vnp_Params.put("Authorization", request.getHeader("Authorization"));
            PaymentCreateDto paymentCreateDto = new PaymentCreateDto().builder()
                    .status("OK")
                    .message("Thực hiện thanh toán")
                    .redirectUrl(paymentUrl)
                    .build();
            return ResponseEntity.ok(vnp_Params);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    @GetMapping("/paymentResult")
    public ResponseEntity<Object> getPaymentResult(HttpServletRequest request,
                                                   @RequestParam(value = "vnp_ResponseCode") String vnp_ResponseCode,
                                                   @RequestParam(value = "vnp_Amount") Double amount) {
        System.out.println(user);
        String userAgent = request.getHeader("User-Agent");
        PaymentResultDto paymentResultDto = new PaymentResultDto();
        if (userAgent != null) {
            if (vnp_ResponseCode.equals("00")) {
                if (userAgent.contains("Mobile")) {
                    if (userAgent.contains("Mobile")) {
                        HttpHeaders httpHeaders = new HttpHeaders();
                        httpHeaders.add("location", "myapp://paymentResult?vnp_ResponseCode=00");
                        return new ResponseEntity<>(httpHeaders, HttpStatus.FOUND);
                    }
                } else if (userAgent.contains("Mozilla")) {
                    HttpHeaders httpHeaders = new HttpHeaders();
                    httpHeaders.add("location", "http://localhost:3000/");
                    orderService.saveOrder(user, "VNPAY", amount, "COMPLETE");
                    return new ResponseEntity<>(httpHeaders, HttpStatus.FOUND);
                }
            } else {
                paymentResultDto.setStatus("FAIL");
                paymentResultDto.setMessage("Thanh toán thất bại");
                ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(paymentResultDto);
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(paymentResultDto);
    }

}
