DO LANGUAGE plpgsql $$
    BEGIN
        IF (SELECT COUNT(*) FROM pg_catalog.pg_namespace WHERE nspname LIKE 'folio\_%') > 0 THEN 
            RAISE NOTICE 'DONE';
        ELSE
            RAISE NOTICE 'NOT DONE';
        END IF;
    END;
$$;
