CREATE OR REPLACE PROCEDURE SUPPLIER_ORDER_DETAILS AS
BEGIN
    FOR supplier_rec IN (
        SELECT
            S.NAME,
            S.CONTACT_NAME,
            SUBSTR(S.CONTACT_NUMBER, 1, INSTR(S.CONTACT_NUMBER, ',') - 1) AS SUPPLIER_CONTACT_No1,
            SUBSTR(S.CONTACT_NUMBER, INSTR(S.CONTACT_NUMBER, ',') + 1) AS SUPPLIER_CONTACT_No2,
            COUNT(O.ID) AS TOTAL_ORDERS,
            TO_CHAR(SUM(O.TOTAL_AMOUNT), '99,999,990.00') AS ORDER_TOTAL_AMOUNT
        FROM
            SUPPLIER S
        LEFT JOIN
            ORDERS O ON S.ID = O.SUPPLIER_ID
        WHERE
            O.ORDER_DATE BETWEEN TO_DATE('01-JAN-2022', 'DD-MON-YYYY') AND TO_DATE('31-AUG-2022', 'DD-MON-YYYY')
        GROUP BY
            S.NAME,
            S.CONTACT_NAME,
            S.CONTACT_NUMBER,
            O.ID,
            O.TOTAL_AMOUNT
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || supplier_rec.NAME);
        DBMS_OUTPUT.PUT_LINE('Supplier Contact Name: ' || supplier_rec.CONTACT_NAME);
        DBMS_OUTPUT.PUT_LINE('Supplier Contact No. 1: ' || supplier_rec.SUPPLIER_CONTACT_No1);
        DBMS_OUTPUT.PUT_LINE('Supplier Contact No. 2: ' || supplier_rec.SUPPLIER_CONTACT_No2);
        DBMS_OUTPUT.PUT_LINE('Total Orders: ' || supplier_rec.TOTAL_ORDERS);
        DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || supplier_rec.ORDER_TOTAL_AMOUNT);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No records found.');
END;