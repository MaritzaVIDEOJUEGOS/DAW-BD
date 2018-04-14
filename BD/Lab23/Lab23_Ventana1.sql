CREATE TABLE Clientes_Banca(
    NoCuenta VARCHAR(5) NOT NULL ,
    Nombre VARCHAR(30),
    Saldo NUMERIC(10,2),
    PRIMARY KEY (NoCuenta),
    CHECK (Saldo>=0)
)
CREATE TABLE Movimientos(
    NoCuenta VARCHAR(5) NOT NULL ,
    ClaveM VARCHAR(2) NOT NULL ,
    Fecha DATETIME,
    Monto NUMERIC(10,2),
    PRIMARY KEY (NoCuenta,ClaveM,Fecha),
    CHECK (Monto>0)
)
CREATE TABLE Tipos_Movimiento(
    ClaveM VARCHAR(2) NOT NULL ,
    Descripcion VARCHAR(30)
    PRIMARY KEY (ClaveM),
)


BEGIN TRANSACTION PRUEBA1
INSERT INTO CLIENTES_BANCA VALUES('001', 'Manuel Rios Maldonado', 9000);
INSERT INTO CLIENTES_BANCA VALUES('002', 'Pablo Perez Ortiz', 5000);
INSERT INTO CLIENTES_BANCA VALUES('003', 'Luis Flores Alvarado', 8000);
COMMIT TRANSACTION PRUEBA1


SELECT * FROM CLIENTES_BANCA

BEGIN TRANSACTION PRUEBA2
INSERT INTO CLIENTES_BANCA VALUES('004','Ricardo Rios Maldonado',19000);
INSERT INTO CLIENTES_BANCA VALUES('005','Pablo Ortiz Arana',15000);
INSERT INTO CLIENTES_BANCA VALUES('006','Luis Manuel Alvarado',18000);

SELECT * FROM CLIENTES_BANCA

ROLLBACK TRANSACTION PRUEBA2


BEGIN TRANSACTION PRUEBA3
INSERT INTO TIPOS_MOVIMIENTO VALUES('A','Retiro Cajero Automatico');
INSERT INTO TIPOS_MOVIMIENTO VALUES('B','Deposito Ventanilla');
COMMIT TRANSACTION PRUEBA3

BEGIN TRANSACTION PRUEBA4
INSERT INTO MOVIMIENTOS VALUES('001','A',GETDATE(),500);
UPDATE CLIENTES_BANCA SET SALDO = SALDO -500
WHERE NoCuenta='001'
COMMIT TRANSACTION PRUEBA4

SELECT * FROM CLIENTES_BANCA
SELECT * FROM Movimientos

BEGIN TRANSACTION PRUEBA5
INSERT INTO CLIENTES_BANCA VALUES('005','Rosa Ruiz Maldonado',9000);
INSERT INTO CLIENTES_BANCA VALUES('006','Luis Camino Ortiz',5000);
INSERT INTO CLIENTES_BANCA VALUES('001','Oscar Perez Alvarado',8000);

IF @@ERROR = 0
COMMIT TRANSACTION PRUEBA5
ELSE
BEGIN
PRINT 'A transaction needs to be rolled back'
ROLLBACK TRANSACTION PRUEBA5
END

SELECT * FROM CLIENTES_BANCA
SELECT * FROM Tipos_Movimiento

 IF EXISTS (SELECT name FROM sysobjects
                       WHERE name = 'REGISTRAR_RETIRO_CAJERO' AND type = 'P')
                DROP PROCEDURE  REGISTRAR_RETIRO_CAJERO
            GO

            CREATE PROCEDURE  REGISTRAR_RETIRO_CAJERO
                @UNoCuenta VARCHAR(5),
                @USaldo NUMERIC(10,2)
            AS
                BEGIN TRANSACTION REGISTRAR_RETIRO_CAJERO
                INSERT INTO MOVIMIENTOS VALUES(@UNoCuenta,'A',GETDATE(),@USaldo);
                UPDATE CLIENTES_BANCA SET SALDO = SALDO -@USaldo
                WHERE NoCuenta=@UNoCuenta

                  IF @@ERROR = 0
                  COMMIT TRANSACTION REGISTRAR_RETIRO_CAJERO
                  ELSE
                  BEGIN
                  PRINT 'A transaction needs to be rolled back'
                  ROLLBACK TRANSACTION PREGISTRAR_RETIRO_CAJERO
                  END

            GO

 EXECUTE  REGISTRAR_RETIRO_CAJERO '001',150.50


SELECT * FROM CLIENTES_BANCA
SELECT * FROM Movimientos

 IF EXISTS (SELECT name FROM sysobjects
                       WHERE name = 'REGISTRAR_DEPOSITO_VENTANILLA ' AND type = 'P')
                DROP PROCEDURE  REGISTRAR_DEPOSITO_VENTANILLA
            GO

            CREATE PROCEDURE REGISTRAR_DEPOSITO_VENTANILLA
                @UNoCuenta VARCHAR(5),
                @USaldo NUMERIC(10,2)
            AS
                BEGIN TRANSACTION REGISTRAR_DEPOSITO_VENTANILLA
                INSERT INTO MOVIMIENTOS VALUES(@UNoCuenta,'B',GETDATE(),@USaldo);
                UPDATE CLIENTES_BANCA SET SALDO = SALDO +@USaldo
                WHERE NoCuenta=@UNoCuenta
                IF @@ERROR = 0
                  COMMIT TRANSACTION REGISTRAR_DEPOSITO_VENTANILLA
                  ELSE
                  BEGIN
                  PRINT 'A transaction needs to be rolled back'
                  ROLLBACK TRANSACTION REGISTRAR_DEPOSITO_VENTANILLA
                  END

            GO

 EXECUTE  REGISTRAR_DEPOSITO_VENTANILLA  '001', 3000.50

SELECT * FROM CLIENTES_BANCA
SELECT * FROM Movimientos