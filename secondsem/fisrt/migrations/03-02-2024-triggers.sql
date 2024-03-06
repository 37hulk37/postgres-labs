CREATE OR REPLACE FUNCTION check_insert_num_sells()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF NEW.num_sells >= 1 THEN
        RETURN NEW;
    ELSE
        RETURN NULL;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION check_insert_producer()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF NEW.type = any(array['Airbus', 'Boeing', 'Tupolev', 'OAK']::varchar[]) THEN
        RETURN NEW;
    ELSE
        RETURN NULL;
    END IF;
END
$$;

CREATE TRIGGER check_insert_num_sells
    BEFORE INSERT OR UPDATE ON planes
    FOR EACH ROW
    EXECUTE PROCEDURE check_insert_num_sells();

CREATE TRIGGER check_insert_producer
    BEFORE INSERT ON planes
    FOR EACH ROW
    EXECUTE PROCEDURE check_insert_producer();