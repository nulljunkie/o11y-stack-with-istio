namespace = "quote-system"

postgres_database = "quotes"
postgres_username = "quoteuser"
postgres_password = "quotepass123"
postgres_init_sql_file = "../apps/db.sql"

server_port = 50051

server_image = "quote-server:v1"
client_v1_image = "quote-client:v1"
client_v2_image = "quote-client:v2"

grafana_admin_password = "admin123"
grafana_nodeport = 30300
