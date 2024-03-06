CREATE OR REPLACE FUNCTION check_insert_mark()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF NEW.value >= 2 AND NEW.value <= 5 THEN
        RETURN NEW;
    ELSE
        RETURN NULL;
    END IF;
END;
$$;

CREATE TRIGGER check_insert_mark
    BEFORE INSERT OR UPDATE ON marks
    FOR EACH ROW
    EXECUTE PROCEDURE check_insert_mark();

INSERT INTO marks (student_id, subject_id, teacher_id, value, year)
VALUES (2, 1, 6, -1, 2023);

CREATE OR REPLACE FUNCTION check_links_to_subject()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF EXISTS(
        SELECT * FROM marks
        WHERE marks.subject_id = OLD.id
    ) THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$;

CREATE TRIGGER check_links_to_subject
    BEFORE UPDATE ON subjects
    FOR EACH ROW
EXECUTE PROCEDURE check_links_to_subject();

UPDATE subjects
    SET name = 'kotlin'
    WHERE id = 2;

CREATE OR REPLACE FUNCTION check_links_to_subject_on_delete()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF EXISTS(
        SELECT * FROM marks
        WHERE marks.subject_id = OLD.id
    ) THEN
        RAISE EXCEPTION 'Subject has links';
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER check_links_to_subject_on_delete
    BEFORE DELETE ON subjects
    FOR EACH ROW
EXECUTE PROCEDURE check_links_to_subject_on_delete();

DELETE FROM subjects
WHERE id = 1;