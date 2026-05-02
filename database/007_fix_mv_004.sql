-- M007: the seed row mv_004 had before_quantity=0, quantity=100,
-- after_quantity=89 with movement_type=IN, which violates the
-- before + qty = after invariant. Adjusting the quantity to 89 keeps
-- the after_quantity (and therefore current_quantity) consistent
-- with the rest of the seed.

BEGIN;

UPDATE stock_movements
SET quantity = 89,
    note = 'Yangi partiya keldi (corrected: was 100, after_quantity 89)'
WHERE id = 'mv_004' AND product_id = 'prod_008';

COMMIT;
