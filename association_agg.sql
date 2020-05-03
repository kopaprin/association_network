--- item master
with item as (
	select
		inventory_id
		, title
		, name 
	from
		inventory
		, film
		, film_category
		, category
	where
		inventory.film_id = film.film_id
		and
		film.film_id = film_category.film_id
		and
		film_category.category_id = category.category_id
), tran as (
	select
		customer_id
		, title
		, name
	from
		rental
		, item
	where
		rental.inventory_id = item.inventory_id
	order by
		customer_id asc
)

select
	"from-to"
	, source_item
	, source_name
	, target_item
	, target_name
	, "AandB"
	, "A"
	, "B"
	, (select count(distinct customer_id) from tran) as "N"
from
	(
	select
		"from-to"
		, source_item
		, source_name
		, target_item
		, target_name
		, count(distinct customer_id) as "AandB"
	from
		(
		select
			tran_a.customer_id
			, tran_a.title as source_item
			, tran_a.name as source_name
			, tran_b.title as target_item
			, tran_b.name as target_name
			, tran_a.title || ' - ' || tran_b.title as "from-to"
		from
			tran as tran_a
			inner join
				tran as tran_b
				on tran_a.customer_id = tran_b.customer_id
				and tran_a.title <> tran_b.title		
		) as fromto 
	group by
		"from-to"
		, source_item
		, source_name
		, target_item
		, target_name
	) as fromto 
	
	inner join(
		select
			tran.title
			, count (distinct customer_id) as "A"
		from
			tran
		group by
			tran.title
	) as source_table
	on fromto.source_item = source_table.title
	
	inner join(
		select
			tran.title
			, count (distinct customer_id) as "B"
		from
			tran
		group by
			tran.title
	) as target_table
	on fromto.target_item = target_table.title
	
	;
