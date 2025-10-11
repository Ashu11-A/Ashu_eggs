#!/bin/ash

# --- Configuration File Paths ---
NGINX_CONF="/home/container/nginx/nginx.conf"
PHP_FPM_CONF="/home/container/php-fpm/php-fpm.conf"
# Assuming the pool config is named www.conf, which is standard.
PHP_POOL_CONF="/home/container/php-fpm/fpm.pool.d/www.conf" 

echo "🔧 Modifying service configurations to redirect log output to the console..."

# --- 1. Modify Nginx Configuration (nginx.conf) ---
if [ -f "$NGINX_CONF" ]; then
    echo "📄 Processing Nginx config: $NGINX_CONF"
    
    # Redirect access logs from file to standard output.
    sed -i 's#^\s*access_log\s*/home/container/logs/access.log;#access_log /dev/stdout;#' "$NGINX_CONF"
    
    # Redirect error logs from file to standard error.
    sed -i 's#^\s*error_log\s*/home/container/logs/error.log;#error_log /dev/stderr;#' "$NGINX_CONF"
    
    echo "✅ Nginx: Changed log location from files to console output (stdout/stderr)."
else
    echo "⚠️ Nginx config not found at $NGINX_CONF"
fi


# --- 2. Modify PHP-FPM Global Configuration (php-fpm.conf) ---
if [ -f "$PHP_FPM_CONF" ]; then
    echo "📄 Processing PHP-FPM global config: $PHP_FPM_CONF"

    # Ensure PHP-FPM runs in the foreground.
    sed -i 's#^;*daemonize\s*=\s*yes#daemonize = no#' "$PHP_FPM_CONF"
    
    # Redirect the main FPM error log to standard error.
    sed -i 's#^error_log\s*=\s*.*#error_log = /proc/self/fd/2#' "$PHP_FPM_CONF"
    
    echo "✅ PHP-FPM: Set to run in foreground and changed main error log location to console."
else
    echo "⚠️ PHP-FPM global config not found at $PHP_FPM_CONF"
fi


# --- 3. Modify PHP-FPM Pool Configuration (www.conf) ---
# This is necessary to capture logs from the actual PHP workers.
if [ -f "$PHP_POOL_CONF" ]; then
    echo "📄 Processing PHP-FPM pool config: $PHP_POOL_CONF"

    # Ensure worker logs (like PHP errors) are sent to the main FPM error log.
    sed -i 's#^;*catch_workers_output\s*=\s*.*#catch_workers_output = yes#' "$PHP_POOL_CONF"
    
    echo "✅ PHP-FPM Pool: Enabled worker log catching to forward PHP errors to the console."
else
    echo "ℹ️ PHP-FPM pool config ($PHP_POOL_CONF) not found. Skipping."
fi

echo "✨ Log location modifications complete!"