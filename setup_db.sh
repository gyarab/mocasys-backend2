#!/usr/bin/env bash
psql "$@" \
    -c "CREATE EXTENSION IF NOT EXISTS plperl" \
    -c "DROP SCHEMA public CASCADE" \
    -c "CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO dvdkon; GRANT ALL ON SCHEMA public TO public; CREATE EXTENSION temporal_tables" \
    -f dascore-be/table_funcs.sql \
    -f dascore-be/auth.sql \
    -f create_schema.sql \
    -f permissions.sql \
    -f functions.sql \
    -f sample_data.sql 
