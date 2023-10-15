import { createBrowserRouter } from "react-router-dom";
import CartDetail from "../components/cart/CartDetail";
import CollectionsLayout from "../layouts/CollectionsLayout";
import HomePage from "../pages/home/HomePage";
import LoadingPage from "../pages/loading/LoadingPage";
import Login from "../pages/login/Login";
import Detail from "../pages/product-detail/Detail";
import Products from "../pages/products/Products";
import Register from "../pages/register/Register";
import CheckOut from "../components/checkout/CheckOut";
import User from "../components/user/User";
const routers = createBrowserRouter([
  {
    path: "/",
    element: <HomePage />,
  },
  {
    path: "*",
    element: <LoadingPage />,
  },
  {
    path: "/checkouts",
    element: <CollectionsLayout />,
    children: [
      {
        path: ":idCart",
        element: <CheckOut />,
      },
      {
        path: "",
        element: <User onLogin={true} />,
      },
    ],
  },
  {
    path: "/cart",
    element: <CollectionsLayout />,
    children: [
      {
        path: "",
        element: <CartDetail />,
      },
      {
        path: "information",
        element: <CartDetail />,
      },
    ],
  },
  {
    path: "/account",
    element: <CollectionsLayout />,

    children: [
      {
        path: "login",
        element: <Login />,
      },
      {
        path: "register",
        element: <Register />,
      },
      {
        path: "",
        element: <></>,
      },
    ],
  },
  {
    path: "/collections",
    element: <CollectionsLayout />,
    children: [
      {
        path: "TOPS",
        element: <Products />,

        index: true,
      },
      {
        path: "BOTTOMS",
        element: <Products />,
      },
      {
        path: "Accessories",
        element: <Products />,
      },
    ],
    default: true,
  },
  {
    path: "/smart-devices",
    element: <CollectionsLayout />,
    children: [
      {
        path: "PHONES",
        element: <LoadingPage />,
      },
      {
        path: "LAPTOPS",
        element: <LoadingPage />,
      },
    ],
  },
  {
    path: "/products",
    element: <CollectionsLayout />,
    children: [
      { path: "", element: <Products /> },
      { path: ":idProduct", element: <Detail /> },
    ],
  },
]);
export default routers;
