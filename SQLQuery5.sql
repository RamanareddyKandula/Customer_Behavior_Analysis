select Top 20* from customer_data

select gender, sum(purchase_amount) as Total_revenue from customer_data 
group by gender

select customer_id,purchase_amount from 
customer_data where discount_applied = 'Yes' and purchase_amount >=(select avg(purchase_amount) from customer_data) 

select top 5 item_purchased,round(avg(review_rating),2) as Average_product_rating from customer_data
group by item_purchased
order by avg(review_rating) desc

select shipping_type,round(avg(cast(purchase_amount as float)),2) as "Avg_purchase_amount" from customer_data where
shipping_type in ('Express','Standard')
group by shipping_type 


select  subscription_status,count(customer_id) as total_customers,
round(avg(cast(purchase_amount as float)),2) as avg_purchase_amount,
CAST(ROUND(SUM(CAST(purchase_amount AS FLOAT)), 2) AS DECIMAL(10,2)) AS total_revenue
from customer_data
group by subscription_status 
order by total_revenue desc


select top 5 item_purchased,
cast(round(cast(100* sum(case when discount_applied = 'yes' then 1 else 0 end)/count(*) as float),2)
as decimal(10,2)) as discount_rate
from customer_data  
group by item_purchased
order by discount_rate desc


with customer_type as (
select  customer_id,previous_purchases,
case 
when previous_purchases = 1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal' end 
as customer_segment
from customer_data)
select customer_segment,count(*) as Number_of_customers
from customer_type 
group by customer_segment;





with item_counts as(
select  item_purchased , category, count(customer_id) as Total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank from customer_data 
group by category, item_purchased)

select item_rank ,category,item_purchased,total_orders from item_counts where item_rank <=3;


select subscription_status,count(customer_id) as repeat_buyers from customer_data
where previous_purchases >= 5 
group by subscription_status


select sum(purchase_amount) as total_revenue,
age_group from customer_data 
group by age_group
order by total_revenue desc