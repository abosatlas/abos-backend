BEGIN;

-- ==========================================================
-- SALES MODULE
-- ==========================================================

-- ==========================================================
-- Product Categories
-- ==========================================================

CREATE TABLE IF NOT EXISTS product_categories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    parent_id UUID REFERENCES product_categories(id) ON DELETE SET NULL,

    name VARCHAR(255) NOT NULL,

    code VARCHAR(50),

    description TEXT,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,name)

);

SELECT create_updated_at_trigger('product_categories');

CREATE INDEX idx_product_categories_company
ON product_categories(company_id);

CREATE INDEX idx_product_categories_parent
ON product_categories(parent_id);

-- ==========================================================
-- Products
-- ==========================================================

CREATE TABLE IF NOT EXISTS products (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    category_id UUID REFERENCES product_categories(id) ON DELETE SET NULL,

    sku VARCHAR(100) NOT NULL,

    barcode VARCHAR(100),

    name VARCHAR(255) NOT NULL,

    description TEXT,

    unit VARCHAR(50) NOT NULL,

    cost NUMERIC(18,2) DEFAULT 0,

    price NUMERIC(18,2) DEFAULT 0,

    vat_rate NUMERIC(5,2) DEFAULT 0,

    minimum_stock NUMERIC(18,2) DEFAULT 0,

    is_service BOOLEAN DEFAULT FALSE,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(company_id,sku)

);

SELECT create_updated_at_trigger('products');

CREATE INDEX idx_products_company
ON products(company_id);

CREATE INDEX idx_products_category
ON products(category_id);

CREATE INDEX idx_products_name
ON products(name);

-- ==========================================================
-- Price Lists
-- ==========================================================

CREATE TABLE IF NOT EXISTS price_lists (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    valid_from DATE,

    valid_to DATE,

    status status_type NOT NULL DEFAULT 'active',

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMP NOT NULL DEFAULT NOW()

);

SELECT create_updated_at_trigger('price_lists');

CREATE INDEX idx_price_lists_company
ON price_lists(company_id);

-- ==========================================================
-- Price List Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS price_list_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    price_list_id UUID NOT NULL REFERENCES price_lists(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

    price NUMERIC(18,2) NOT NULL,

    UNIQUE(price_list_id,product_id)

);

CREATE INDEX idx_price_list_items_list
ON price_list_items(price_list_id);

-- ==========================================================
-- Quotations
-- ==========================================================

CREATE TABLE IF NOT EXISTS quotations (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

    customer_id UUID NOT NULL REFERENCES customers(id),

    quotation_number VARCHAR(100) NOT NULL,

    quotation_date DATE NOT NULL,

    valid_until DATE,

    subtotal NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    total_amount NUMERIC(18,2) DEFAULT 0,

    notes TEXT,

    status status_type DEFAULT 'active',

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,quotation_number)

);

SELECT create_updated_at_trigger('quotations');

CREATE INDEX idx_quotations_customer
ON quotations(customer_id);

-- ==========================================================
-- Quotation Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS quotation_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    quotation_id UUID NOT NULL REFERENCES quotations(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL,

    unit_price NUMERIC(18,2) NOT NULL,

    discount NUMERIC(18,2) DEFAULT 0,

    tax NUMERIC(18,2) DEFAULT 0,

    total NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_quotation_items_quote
ON quotation_items(quotation_id);

-- ==========================================================
-- Sales Orders
-- ==========================================================

CREATE TABLE IF NOT EXISTS sales_orders (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    customer_id UUID NOT NULL REFERENCES customers(id),

    quotation_id UUID REFERENCES quotations(id),

    order_number VARCHAR(100) NOT NULL,

    order_date DATE NOT NULL,

    subtotal NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    total_amount NUMERIC(18,2) DEFAULT 0,

    notes TEXT,

    status status_type DEFAULT 'active',

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,order_number)

);

SELECT create_updated_at_trigger('sales_orders');

CREATE INDEX idx_sales_orders_customer
ON sales_orders(customer_id);

-- ==========================================================
-- Sales Order Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS sales_order_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    sales_order_id UUID NOT NULL REFERENCES sales_orders(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL,

    unit_price NUMERIC(18,2) NOT NULL,

    discount NUMERIC(18,2) DEFAULT 0,

    tax NUMERIC(18,2) DEFAULT 0,

    total NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_sales_order_items_order
ON sales_order_items(sales_order_id);

-- ==========================================================
-- Invoices
-- ==========================================================

CREATE TABLE IF NOT EXISTS invoices (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_id UUID NOT NULL REFERENCES companies(id),

    customer_id UUID NOT NULL REFERENCES customers(id),

    sales_order_id UUID REFERENCES sales_orders(id),

    invoice_number VARCHAR(100) NOT NULL,

    invoice_date DATE NOT NULL,

    due_date DATE,

    subtotal NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    total_amount NUMERIC(18,2) DEFAULT 0,

    paid_amount NUMERIC(18,2) DEFAULT 0,

    payment_status payment_status DEFAULT 'pending',

    invoice_status invoice_status DEFAULT 'draft',

    notes TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(company_id,invoice_number)

);

SELECT create_updated_at_trigger('invoices');

CREATE INDEX idx_invoices_customer
ON invoices(customer_id);

CREATE INDEX idx_invoices_status
ON invoices(invoice_status);

-- ==========================================================
-- Invoice Items
-- ==========================================================

CREATE TABLE IF NOT EXISTS invoice_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity NUMERIC(18,2) NOT NULL,

    unit_price NUMERIC(18,2) NOT NULL,

    discount NUMERIC(18,2) DEFAULT 0,

    tax NUMERIC(18,2) DEFAULT 0,

    total NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_invoice_items_invoice
ON invoice_items(invoice_id);

COMMIT;
