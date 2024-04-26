CREATE OR REPLACE PROCEDURE ORDER_INVOICE_SUMMARY_REPORT AS
BEGIN
    FOR order_rec IN (
        SELECT 
            REGEXP_REPLACE(O.REFERENCE, 'PO', '') AS ORDER_REFERENCE,
            TO_CHAR(O.ORDER_DATE, 'MON-YYYY') AS PERIOD,
            INITCAP(S.NAME) AS NAME,
            TO_CHAR(O.TOTAL_AMOUNT, '99,999,990.00') AS ORDER_TOTAL_AMOUNT,
            O.STATUS,
            I.REFERENCE,
            TO_CHAR(I.AMOUNT, '99,999,990.00') AS INVOICE_TOTAL_AMOUNT,
            CASE 
                WHEN COUNT(*) = COUNT(CASE WHEN I.STATUS = 'Paid' THEN 1 END) THEN 'OK'
                WHEN COUNT(*) <> COUNT(CASE WHEN I.STATUS = 'Paid' THEN 1 END) 
                     AND COUNT(*) = COUNT(CASE WHEN I.STATUS = 'Pending' THEN 1 END) THEN 'To follow up'
                ELSE 'To verify'
            END AS ACTION
        FROM ORDERS O
        LEFT JOIN SUPPLIER S ON O.SUPPLIER_ID = S.ID
        LEFT JOIN INVOICE I ON O.ID = I.ORDER_ID
        GROUP BY 
            O.REFERENCE,
            O.ORDER_DATE,
            S.NAME,
            O.TOTAL_AMOUNT,
            O.STATUS,
            I.REFERENCE,
            I.AMOUNT
        ORDER BY O.ORDER_DATE DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Order Reference: ' || order_rec.ORDER_REFERENCE);
        DBMS_OUTPUT.PUT_LINE('Order Period: ' || order_rec.PERIOD);
        DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || order_rec.NAME);
        DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || NVL(order_rec.ORDER_TOTAL_AMOUNT, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Order Status: ' || order_rec.STATUS);
        DBMS_OUTPUT.PUT_LINE('Invoice Reference: ' || NVL(order_rec.REFERENCE, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Invoice Total Amount: ' || NVL(order_rec.INVOICE_TOTAL_AMOUNT, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Action: ' || order_rec.ACTION);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END LOOP;
END;