import { Breadcrumb, Layout, Space } from "antd";
import { Content } from "antd/es/layout/layout";
import React, { useEffect, useState } from "react";
import { Link, Outlet, useLocation } from "react-router-dom";
import HeaderPage from "../components/header/HeaderPage";
import Introductions from "../components/introductions/Introductions";
import "./CollectionsLayout.scss";
import usePageTitle from "../hooks/usePageTitle";

const CollectionsLayout = (props) => {
  const { pathname } = useLocation();
  const [, setMainPath] = useState("");
  const pathArr = pathname.split("/").filter((item) => item);
  usePageTitle();
  useEffect(() => {
    setMainPath(pathArr[0]);
  }, [pathArr]);

  const itemBreadcrumb = pathArr.map((path) =>
    path === pathArr[pathArr.length - 1]
      ? { title: path }
      : { title: <Link to={`/${path}`}>{path}</Link> }
  );
  return (
    <Layout style={{ height: "100vh" }}>
      <HeaderPage />
      <div style={{ height: "500px", display: "block" }}></div>
      <Content>
        <Space className="breadcrumb_wrapper">
          <Breadcrumb
            items={[{ title: <Link to={"/"}>Home</Link> }, ...itemBreadcrumb]}
          ></Breadcrumb>
        </Space>

        <Layout className="mainPage">
          <Outlet />
        </Layout>
        <Introductions></Introductions>
      </Content>
    </Layout>
  );
};

export default CollectionsLayout;
