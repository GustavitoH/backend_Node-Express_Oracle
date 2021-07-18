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

INSERT INTO FACTURA(cliente, fecha, subtotal, total) VALUES('David Millán', SYSDATE, 100, 112);
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

INSERT INTO KARDEX(producto, fecha, accion) VALUES('Celular', SYSDATE, 'Se vendieron 2 artículos');
------------------------------------------------ PROCEDIMIENTOS ALMACENADOS ----------------------------------------------------------------------------------------------------------------
-- INSERTAR PRODUCTO
create or replace PROCEDURE Insertar_Producto(producto VARCHAR2, precio NUMBER, descripcion VARCHAR2, cantidad NUMBER)
is
begin
  IF precio > 0 THEN
      INSERT INTO PRODUCTO (PRODUCTO, PRECIO, DESCRIPCION, CANTIDAD) VALUES (producto, precio, descripcion, cantidad);
      DBMS_OUTPUT.PUT_LINE('PRODUCTO INGRESADO EXISTOSAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('PRECIO DE PRODUCTO NO VALIDO');
  END IF;
END;

--EJECUCIÓN
EXEC Insertar_Producto('Teclado', 10.20, 'Color negro', 12);
select * from COUNTRIES;

-- INSERTAR PRODUCTO
create or replace PROCEDURE Insertar_Producto(producto VARCHAR2, precio NUMBER, descripcion VARCHAR2, cantidad NUMBER)
is
begin
  IF precio > 0 THEN
      INSERT INTO PRODUCTO (PRODUCTO, PRECIO, DESCRIPCION, CANTIDAD) VALUES (producto, precio, descripcion, cantidad);
      DBMS_OUTPUT.PUT_LINE('PRODUCTO INGRESADO EXISTOSAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('PRECIO DE PRODUCTO NO VALIDO');
  END IF;
END;

--EJECUCIÓN
EXEC Insertar_Producto('Teclado', 10.20, 'Color negro', 12);
select * from COUNTRIES;

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
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE INGRESARON ' || cantidad_producto || ' ARTÍCULOS.' );    
    END IF;
    IF UPDATING THEN    
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE MODIFICARON ' || cantidad_producto || ' ARTÍCULOS.');    
    END IF;
    IF DELETING THEN    
    INSERT INTO KARDEX (PRODUCTO, FECHA, ACCION) VALUES(nombre_producto, fecha_factura, 'SE ELIMINARON ' || cantidad_producto || ' ARTÍCULOS.');    
    END IF;
END;
