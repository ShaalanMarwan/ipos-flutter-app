import 'package:powersync/powersync.dart';

final schema = Schema([
  // Users table
  Table('users', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('branch_id'),
    Column.text('email'),
    Column.text('name'),
    Column.text('role'),
    Column.text('phone'),
    Column.text('avatar_url'),
    Column.integer('is_active'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_users_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_users_branch', [IndexedColumn('branch_id')]),
    Index('idx_users_email', [IndexedColumn('email')]),
  ]),

  // Branches table
  Table('branches', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('name'),
    Column.text('code'),
    Column.text('address'),
    Column.text('phone'),
    Column.text('email'),
    Column.integer('is_active'),
    Column.text('timezone'),
    Column.text('currency'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_branches_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_branches_code', [IndexedColumn('code')]),
  ]),

  // Categories table
  Table('categories', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('name'),
    Column.text('slug'),
    Column.text('description'),
    Column.text('parent_id'),
    Column.integer('sort_order'),
    Column.integer('is_active'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_categories_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_categories_parent', [IndexedColumn('parent_id')]),
    Index('idx_categories_slug', [IndexedColumn('slug')]),
  ]),

  // Products table
  Table('products', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('category_id'),
    Column.text('name'),
    Column.text('sku'),
    Column.text('barcode'),
    Column.text('description'),
    Column.real('price'),
    Column.real('cost'),
    Column.text('unit'),
    Column.integer('is_active'),
    Column.integer('track_inventory'),
    Column.text('image_url'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_products_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_products_category', [IndexedColumn('category_id')]),
    Index('idx_products_sku', [IndexedColumn('sku')]),
    Index('idx_products_barcode', [IndexedColumn('barcode')]),
  ]),

  // Inventory table
  Table('inventory', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('branch_id'),
    Column.text('product_id'),
    Column.real('quantity'),
    Column.real('reserved_quantity'),
    Column.real('min_quantity'),
    Column.real('max_quantity'),
    Column.text('last_restock_date'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_inventory_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_inventory_branch', [IndexedColumn('branch_id')]),
    Index('idx_inventory_product', [IndexedColumn('product_id')]),
  ]),

  // Orders table
  Table('orders', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('branch_id'),
    Column.text('order_number'),
    Column.text('status'),
    Column.text('order_type'),
    Column.text('payment_status'),
    Column.text('payment_method'),
    Column.real('subtotal'),
    Column.real('tax_amount'),
    Column.real('discount_amount'),
    Column.real('total_amount'),
    Column.real('paid_amount'),
    Column.text('customer_name'),
    Column.text('customer_phone'),
    Column.text('customer_email'),
    Column.text('table_number'),
    Column.text('notes'),
    Column.text('created_by'),
    Column.text('created_at'),
    Column.text('updated_at'),
    Column.text('completed_at'),
  ], indexes: [
    Index('idx_orders_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_orders_branch', [IndexedColumn('branch_id')]),
    Index('idx_orders_number', [IndexedColumn('order_number')]),
    Index('idx_orders_status', [IndexedColumn('status')]),
    Index('idx_orders_created', [IndexedColumn('created_at')]),
  ]),

  // Order items table
  Table('order_items', [
    Column.text('id'),
    Column.text('order_id'),
    Column.text('product_id'),
    Column.text('product_name'),
    Column.real('quantity'),
    Column.real('unit_price'),
    Column.real('discount_amount'),
    Column.real('tax_amount'),
    Column.real('total_amount'),
    Column.text('notes'),
    Column.text('modifiers'),
    Column.text('status'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_order_items_order', [IndexedColumn('order_id')]),
    Index('idx_order_items_product', [IndexedColumn('product_id')]),
    Index('idx_order_items_status', [IndexedColumn('status')]),
  ]),

  // Kitchen orders table (for kitchen display)
  Table('kitchen_orders', [
    Column.text('id'),
    Column.text('order_id'),
    Column.text('branch_id'),
    Column.text('status'),
    Column.text('priority'),
    Column.text('assigned_to'),
    Column.text('started_at'),
    Column.text('completed_at'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_kitchen_orders_order', [IndexedColumn('order_id')]),
    Index('idx_kitchen_orders_branch', [IndexedColumn('branch_id')]),
    Index('idx_kitchen_orders_status', [IndexedColumn('status')]),
    Index('idx_kitchen_orders_assigned', [IndexedColumn('assigned_to')]),
  ]),

  // Settings table
  Table('settings', [
    Column.text('id'),
    Column.text('tenant_id'),
    Column.text('branch_id'),
    Column.text('key'),
    Column.text('value'),
    Column.text('category'),
    Column.text('created_at'),
    Column.text('updated_at'),
  ], indexes: [
    Index('idx_settings_tenant', [IndexedColumn('tenant_id')]),
    Index('idx_settings_branch', [IndexedColumn('branch_id')]),
    Index('idx_settings_key', [IndexedColumn('key')]),
    Index('idx_settings_category', [IndexedColumn('category')]),
  ]),
]);