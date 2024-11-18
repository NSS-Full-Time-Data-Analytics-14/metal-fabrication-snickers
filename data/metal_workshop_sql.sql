SELECT omp_customer_organization_id, SUM(omp_order_total_base)::int as total_sales
FROM sales_orders
GROUP BY omp_customer_organization_id
ORDER BY total_sales DESC
