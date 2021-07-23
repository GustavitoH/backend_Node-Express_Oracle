----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE PRODUCTO(
   id NUMBER PRIMARY KEY,
   producto VARCHAR2(50),
   precio NUMBER(6,2),
   descripcion VARCHAR2(100),
   cantidad NUMBER
);

CREATE SEQUENCE ai_producto
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER incrementar_id
BEFORE INSERT ON PRODUCTO
FOR EACH ROW
BEGIN
SELECT ai_producto.NEXTVAL INTO :NEW.id FROM DUAL;
END;

INSERT INTO PRODUCTO(producto, precio, descripcion, cantidad) VALUES('Celular', 1200, 'Color negro', 12);
INSERT INTO PRODUCTO(producto, precio, descripcion, cantidad) VALUES('Tablet', 120.50, 'Color blanco', 10);
INSERT INTO PRODUCTO(producto, precio, descripcion, cantidad) VALUES('Laptop', 151, 'Color rosa', 8);
INSERT INTO PRODUCTO(producto, precio, descripcion, cantidad) VALUES('Carcasa', 205.23, 'Color gris', 20);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE FACTURA (
  id NUMBER PRIMARY KEY,
  cliente VARCHAR2(50),
  fecha DATE,
  subtotal NUMBER(6,2),
  total NUMBER(6,2)
);

CREATE SEQUENCE ai_factura
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER incrementar_id_fact
BEFORE INSERT ON FACTURA
FOR EACH ROW
BEGIN
SELECT ai_factura.NEXTVAL INTO :NEW.id FROM DUAL;
END;

INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('David MillÃ¡n', SYSDATE, 100, 112);
INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('Kevin Pillacela', SYSDATE, 80, 100);
INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('Joel Cujilema', SYSDATE, 300, 320);
INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('Joseph Alejandro', SYSDATE, 320, 350);
INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('Gustavo Hidalgo', SYSDATE, 450, 460);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE DETALLE_FACTURA (
  id_factura NUMBER,
  id_producto NUMBER,
  cantidad NUMBER(6,2),
  preciounit NUMBER(6,1),
  precio NUMBER(6,1),
  CONSTRAINT fk_idfactura FOREIGN KEY (id_factura) REFERENCES FACTURA(id),
  CONSTRAINT fk_idproducto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id)
);
INSERT INTO DETALLE_FACTURA(id_factura, id_producto, cantidad, preciounit, precio) VALUES(21, 1, 2, 50.75, 105);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE KARDEX (
  id NUMBER PRIMARY KEY,
  producto VARCHAR2(50),
  fecha DATE,
  accion VARCHAR2(100)
);

CREATE SEQUENCE ai_kardex
START WITH 1
INCREMENT BY 1;

CREATE TRIGGER incrementar_id_kardex
BEFORE INSERT ON KARDEX
FOR EACH ROW
BEGIN
SELECT ai_kardex.NEXTVAL INTO :NEW.id FROM DUAL;
END;

INSERT INTO KARDEX(producto, fecha, accion) VALUES('Celular', SYSDATE, 'Se vendieron 2 ARTICULOS');
------------------------------------------------ PROCEDIMIENTOS ALMACENADOS ----------------------------------------------------------------------------------------------------------------
-- INSERTAR PRODUCTO
CREATE OR REPLACE PROCEDURE Insertar_Producto(producto VARCHAR2, precio NUMBER, descripcion VARCHAR2, cantidad NUMBER)
is
begin
  IF (precio > 0 AND cantidad >= 0) THEN
    INSERT INTO PRODUCTO (PRODUCTO, PRECIO, DESCRIPCION, CANTIDAD) VALUES (producto, precio, descripcion, cantidad);
    DBMS_OUTPUT.PUT_LINE('PRODUCTO INGRESADO EXISTOSAMENTE');
    COMMIT;
  ELSE 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR!');
  END IF;
END;

--EJECUCION
EXEC Insertar_Producto('Monitor MMM', 5, 'Color negro', 0);

-- ACTUALIZAR PRODUCTO
CREATE OR REPLACE PROCEDURE Actualizar_Producto(id1 NUMBER, producto1 VARCHAR2, precio1 NUMBER, descripcion1 VARCHAR2, cantidad1 NUMBER)
is
begin
  IF (precio1 > 0 AND cantidad1 >= 0) THEN
        UPDATE PRODUCTO SET PRODUCTO=producto1, PRECIO=precio1, DESCRIPCION=descripcion1, CANTIDAD=cantidad1 WHERE ID=id1;
    DBMS_OUTPUT.PUT_LINE('PRODUCTO MODIFICADO EXISTOSAMENTE');
    COMMIT;
  ELSE 
      DBMS_OUTPUT.PUT_LINE('MODIFICACION NO VALIDA');
  END IF;
END;

--EJECUTAR
EXEC Actualizar_Producto(81, 'Monitor', 500, 'Color negro', 7);

-- INSERTAR FACTURA
CREATE OR REPLACE PROCEDURE Insertar_Factura(cliente VARCHAR2, subtotal NUMBER, total NUMBER)
is
begin
  IF (total > 0) THEN
    INSERT INTO FACTURA (CLIENTE, FECHA, SUBTOTAL, TOTAL) VALUES (cliente, SYSDATE, subtotal, total);
    DBMS_OUTPUT.PUT_LINE('FACTURA INGRESADA EXISTOSAMENTE');
      COMMIT;
  ELSE 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR!');
  END IF;
END;

--EJECUCION
EXEC Insertar_Factura('Karla Aguilar', 10.50, 15.50);

-- INSERTAR DETALLE_FACTURA
CREATE OR REPLACE PROCEDURE Insertar_DetalleFactura(id_factura NUMBER, id_producto NUMBER, cantidad NUMBER, preciounit NUMBER, precio NUMBER)
is
begin
  IF (cantidad > 0 AND preciounit > 0 AND precio > 0) THEN
    INSERT INTO DETALLE_FACTURA (ID_FACTURA, ID_PRODUCTO, CANTIDAD, PRECIOUNIT, PRECIO) VALUES (id_factura, id_producto, cantidad, preciounit, precio);
    DBMS_OUTPUT.PUT_LINE('DETALLE FACTURA INGRESADO EXISTOSAMENTE');
    COMMIT;
  ELSE 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR!');
  END IF;
END;

--EJECUCION
EXEC Insertar_DetalleFactura(45,81,1,10,20);
------------------------------------------------ TRIGGERS ----------------------------------------------------------------------------------------------------------------
-- CONTROLAR STOCK
CREATE OR REPLACE TRIGGER "TRIGGER_CONTROL_STOCK" AFTER INSERT ON DETALLE_FACTURA FOR EACH ROW
  DECLARE 
  BEGIN
    UPDATE PRODUCTO 
    SET CANTIDAD = CANTIDAD - :new.CANTIDAD
    WHERE PRODUCTO.ID = :new.ID_PRODUCTO;    
END;

-- CONTROL KARDEX
CREATE OR REPLACE TRIGGER "TRIGGER_CONTROL_KARDEX" 
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_FACTURA FOR EACH ROW
  DECLARE   
  nombre_producto varchar2(50 byte);
  fecha_factura date;  
  cantidad_producto varchar2(50 byte);
  BEGIN    
  nombre_producto := '';
  fecha_factura := '';  
  cantidad_producto :=  '';
  SELECT cast(:new.CANTIDAD As VARCHAR2(50)) INTO cantidad_producto FROM dual;
  
    select PRODUCTO.PRODUCTO into nombre_producto FROM producto WHERE producto.id = :new.ID_PRODUCTO;
    select FACTURA.FECHA into fecha_factura FROM FACTURA WHERE factura.id = :new.ID_FACTURA;    
    
    IF INSERTING THEN        
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE VENDIERON ' || cantidad_producto || ' ARTÍCULOS.' );    
    END IF;
    IF UPDATING THEN    
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE VENDIERON ' || cantidad_producto || ' ARTÍCULOS.');    
    END IF;
    IF DELETING THEN    
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE VENDIERON ' || cantidad_producto || ' ARTÍCULOS.');    
    END IF;
END;

---------------------------FUNCTIONS---------------------------
/*
*FunciÃ³n que retorna el producto mÃ¡s vendido con la cantidad
*/
CREATE OR REPLACE FUNCTION producto_mas_vendido
RETURN VARCHAR IS
PRODUCTO_ID NUMBER;
PRODUCTO_NOMBRE VARCHAR(50);
CANTIDAD NUMBER;
MENSAJE VARCHAR(50);
BEGIN
  SELECT ID_PRODUCTO AS PRODUCTO, SUM(CANTIDAD) INTO PRODUCTO_ID, CANTIDAD FROM DETALLE_FACTURA GROUP BY ID_PRODUCTO ORDER BY SUM(CANTIDAD) DESC FETCH FIRST 1 ROW ONLY;
  SELECT PRODUCTO INTO PRODUCTO_NOMBRE FROM PRODUCTO WHERE ID = PRODUCTO_ID;
  MENSAJE := PRODUCTO_NOMBRE || ',' || CANTIDAD;
  RETURN MENSAJE;
END;

SELECT PRODUCTO_MAS_VENDIDO FROM DUAL;

/*
*FunciÃ³n que retorna el producto menos vendido con la cantidad
*/
CREATE OR REPLACE FUNCTION producto_menos_vendido
RETURN VARCHAR IS
PRODUCTO_ID NUMBER;
PRODUCTO_NOMBRE VARCHAR(50);
CANTIDAD NUMBER;
MENSAJE VARCHAR(50);
BEGIN
  SELECT ID_PRODUCTO AS PRODUCTO, SUM(CANTIDAD) INTO PRODUCTO_ID, CANTIDAD FROM DETALLE_FACTURA GROUP BY ID_PRODUCTO ORDER BY SUM(CANTIDAD) ASC FETCH FIRST 1 ROW ONLY;
  SELECT PRODUCTO INTO PRODUCTO_NOMBRE FROM PRODUCTO WHERE ID = PRODUCTO_ID;
  MENSAJE := PRODUCTO_NOMBRE || ',' || CANTIDAD;
  RETURN MENSAJE;
END;

SELECT PRODUCTO_MENOS_VENDIDO FROM DUAL;

/*
*Funcion que retorna el total de ventas del dia
*/
CREATE OR REPLACE FUNCTION TOTAL_VENTA_HOY
RETURN NUMBER IS
TOTAL_VENDIDO NUMBER;
NUMERO_FILAS NUMBER;
BEGIN
  SELECT COUNT(*) INTO NUMERO_FILAS FROM FACTURA WHERE TRUNC(FECHA) = TRUNC(SYSDATE);
  IF NUMERO_FILAS > 0 THEN
    SELECT SUM(TOTAL) INTO TOTAL_VENDIDO FROM FACTURA WHERE TRUNC(FECHA) = TRUNC(SYSDATE);
  ELSE
      TOTAL_VENDIDO := 0;
  END IF;
  RETURN TOTAL_VENDIDO;
END;

SELECT TOTAL_VENTA_HOY FROM DUAL;

----------------CREATE VIEWS------------------
CREATE OR REPLACE VIEW V_DETALLE_FACTURA AS SELECT DE.ID_FACTURA, PR.PRODUCTO, DE.CANTIDAD, DE.PRECIOUNIT, DE.PRECIO 
FROM DETALLE_FACTURA DE INNER JOIN PRODUCTO PR ON PR.ID = DE.ID_PRODUCTO;

SELECT * FROM V_DETALLE_FACTURA;

 SELECT SUM(CANTIDAD) FROM PRODUCTO;
 
