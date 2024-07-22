--CREACIÓN DE BASE
CREATE DATABASE Cerveceria
GO

USE Cerveceria
GO


--CREACIÓN DE TABLAS
CREATE TABLE Marcas_Cerveza
(
codMarca_MC char(10) NOT NULL,
NombreMarca_MC varchar(30) NOT NULL,
CONSTRAINT PK_Marcas_Cerveza PRIMARY KEY (codMarca_MC)
)

CREATE TABLE Tipos_Cerveza
(
codMarca_TC char(10) NOT NULL,
codTipo_TC char(10) NOT NULL,
NombreTipo_TC varchar(30) NOT NULL,
Descripcion_TC varchar(150) NOT NULL,
CONSTRAINT PK_Tipos_Cerveza PRIMARY KEY (codMarca_TC, codTipo_TC),
CONSTRAINT FK_Tipos_Cerveza_Marcas_Cerveza FOREIGN KEY (codMarca_TC) REFERENCES Marcas_Cerveza (codMarca_MC)
)

CREATE TABLE Presentaciones
(
IdPresentacion_Pre char(2) NOT NULL,
NombrePresentacion_Pre varchar(30) NOT NULL,
CONSTRAINT PK_Presentaciones PRIMARY KEY (IdPresentacion_Pre)
)

CREATE TABLE Cervezas
(
codCerveza_Ce char(10) NOT NULL,
codMarca_Ce char(10) NOT NULL,
codTipo_Ce char(10) NOT NULL,
IdPresentacion_Ce char(2) NOT NULL,
PrecioUnitarioCompra_Ce decimal(8,2) NOT NULL CHECK(PrecioUnitarioCompra_Ce >= 0) DEFAULT 0,
PrecioUnitarioVenta_Ce decimal(8,2) NOT NULL CHECK(PrecioUnitarioVenta_Ce >= 0) DEFAULT 0,
Stock_Ce int NOT NULL CHECK(Stock_Ce >= 0) DEFAULT 0,
UrlImagen_Ce varchar(100) NULL,
Estado_Ce bit NOT NULL DEFAULT 1,
CONSTRAINT PK_Cervezas PRIMARY KEY (codCerveza_Ce),
CONSTRAINT FK_Cervezas_Tipos_Cerveza FOREIGN KEY (codMarca_Ce, codTipo_Ce) REFERENCES Tipos_Cerveza (codMarca_TC, codTipo_TC),
CONSTRAINT FK_Cervezas_Presentaciones FOREIGN KEY (IdPresentacion_Ce) REFERENCES Presentaciones (IdPresentacion_Pre)
)

CREATE TABLE Pedidos
(
IdPedido_Pe int IDENTITY(1,1) NOT NULL,
codMarca_Pe char(10) NOT NULL,
Fecha_Pe datetime NOT NULL,
Total_Pe decimal(8,2) NOT NULL CHECK(Total_Pe >= 0) DEFAULT 0,
Estado_Pe bit NOT NULL DEFAULT 0,
CONSTRAINT PK_Pedidos PRIMARY KEY (IdPedido_Pe),
CONSTRAINT FK_Pedidos_Marcas_Cerveza FOREIGN KEY (codMarca_Pe) REFERENCES Marcas_Cerveza (codMarca_MC)
)

CREATE TABLE DetallePedidos
(
IdPedido_DP int NOT NULL,
codCerveza_DP char(10) NOT NULL,
CantPedido_DP int NOT NULL,
PrecioUnitario_DP decimal(8,2) NOT NULL CHECK(PrecioUnitario_DP >= 0),
CONSTRAINT PK_DetallePedidos PRIMARY KEY (IdPedido_DP, codCerveza_DP),
CONSTRAINT FK_DetallePedidos_Pedidos FOREIGN KEY (IdPedido_DP) REFERENCES Pedidos (IdPedido_Pe),
CONSTRAINT FK_DetallePedidos_Cervezas FOREIGN KEY (codCerveza_DP) REFERENCES Cervezas (codCerveza_Ce)
)

CREATE TABLE Provincias
(
IdProvincia_Pr char(2) NOT NULL,
NombreProvincia_Pr varchar(30) NOT NULL,
CONSTRAINT PK_Provincias PRIMARY KEY (IdProvincia_Pr)
)

CREATE TABLE Localidades
(
IdLocalidad_Lo char(4) NOT NULL,
IdProvincia_Lo char(2) NOT NULL,
NombreLocalidad_Lo varchar(50) NOT NULL,
CONSTRAINT PK_Localidades PRIMARY KEY (IdLocalidad_Lo),
CONSTRAINT FK_Localidades_Provincias FOREIGN KEY (IdProvincia_Lo) REFERENCES Provincias (IdProvincia_Pr)
)

CREATE TABLE Clientes
(
Dni_Cli char(10) NOT NULL,
IdLocalidad_Cli char(4) NOT NULL,
Nombre_Cli varchar(25) NULL,
Apellido_Cli varchar(25) NULL,
Legajo_Cli char(5) NOT NULL,
Contraseña_Cli varchar(15) NOT NULL,
Genero_Cli varchar(10) NULL CHECK(Genero_Cli = 'Masculino' OR Genero_Cli = 'Femenino'),
Telefono_Cli varchar(13) NULL,
Estado_Cli bit NOT NULL DEFAULT 1,
CONSTRAINT PK_Clientes PRIMARY KEY (Dni_Cli),
CONSTRAINT FK_Clientes_Localidades FOREIGN KEY (IdLocalidad_Cli) REFERENCES Localidades (IdLocalidad_Lo),
CONSTRAINT UK_Clientes_Legajo UNIQUE (Legajo_Cli)
)

CREATE TABLE Trabajadores
(
Dni_Tr char(10) NOT NULL,
IdLocalidad_Tr char(4) NOT NULL,
Legajo_Tr char(5) NOT NULL,
Contraseña_Tr varchar(15) NOT NULL,
Nombre_Tr varchar(25) NULL,
Apellido_Tr varchar(25) NULL,
Genero_Tr varchar(10) NULL CHECK(Genero_Tr = 'Masculino' OR Genero_Tr = 'Femenino'),
Telefono_Tr varchar(13) NULL,
FechaIngreso_Tr datetime NOT NULL DEFAULT GETDATE(),
Estado_Tr bit NOT NULL DEFAULT 1,
CONSTRAINT PK_Trabajadores PRIMARY KEY (Dni_Tr),
CONSTRAINT FK_Trabajadores_Localidades FOREIGN KEY (IdLocalidad_Tr) REFERENCES Localidades (IdLocalidad_Lo),
CONSTRAINT UK_Trabajadores_Legajo UNIQUE (Legajo_Tr)
)

CREATE TABLE Ventas
(
codVenta_Ve int IDENTITY(1,1) NOT NULL,
Dni_Cli_Ve char(10) NOT NULL,
Dni_Tr_Ve char(10) NOT NULL,
TotalVenta_Ve decimal(8,2) NOT NULL CHECK(TotalVenta_Ve >= 0) DEFAULT 0,
FechaVenta_Ve datetime NOT NULL DEFAULT GETDATE(),
CONSTRAINT PK_Ventas PRIMARY KEY (codVenta_ve),
CONSTRAINT FK_Ventas_Clientes FOREIGN KEY (Dni_Cli_Ve) REFERENCES Clientes (Dni_Cli),
CONSTRAINT FK_Ventas_Trabajadores FOREIGN KEY (Dni_Tr_Ve) REFERENCES Trabajadores (Dni_Tr)
)

CREATE TABLE DetalleVentas
(
codVenta_DV int NOT NULL,
codCerveza_DV char(10) NOT NULL,
CantVenta_DV int NOT NULL DEFAULT 0,
PrecioUnitario_DV decimal(8,2) NOT NULL CHECK(PrecioUnitario_DV >= 0) DEFAULT 0,
CONSTRAINT PK_DetalleVentas PRIMARY KEY (codVenta_DV, codCerveza_DV),
CONSTRAINT FK_DetalleVentas_Ventas FOREIGN KEY (codVenta_DV) REFERENCES Ventas (codVenta_Ve),
CONSTRAINT FK_DetalleVentas_Cervezas FOREIGN KEY (codCerveza_DV) REFERENCES Cervezas (codCerveza_Ce)
)


--CARGA DE DATOS

INSERT INTO Marcas_Cerveza (codMarca_MC, NombreMarca_MC)
SELECT 1, 'Achel' UNION
SELECT 2, 'Budweiser' UNION
SELECT 3, 'Althaia' UNION
SELECT 4, 'Heineken' UNION
SELECT 5, 'Brahma' UNION
SELECT 6, 'Corona' UNION
SELECT 7, 'Quilmes' UNION
SELECT 8, 'Stella Artois' UNION
SELECT 9, 'Andes' UNION
SELECT 10, 'Schneider' UNION
SELECT 11, 'Patagonia' UNION
SELECT 12, 'Skol' UNION
SELECT 13, 'Mahou' UNION
SELECT 14, 'Estrella Galicia' UNION
SELECT 15, 'HOFBRÄU MÜNCHEN' 
GO

INSERT INTO Tipos_Cerveza (codMarca_TC, codTipo_TC, Descripcion_TC, NombreTipo_TC)
SELECT 1, 1, 'Rubia de maltas claras, ligero aroma a lúpulo, muy ligera. alc. 4% vol.', 'Lager Pilsen' UNION
SELECT 1, 2, 'Rubia dorada, con aromas malteados con notas a lúpulo, muy cremosa', 'Lager Especial' UNION
SELECT 2, 1, 'La lager con mas graduación alcoholica entre 6% y 7%, color cobrizo', 'Lager Extra' UNION
SELECT 2, 2, 'Rubia dorada, con aromas malteados con notas a lúpulo, muy cremosa', 'Lager Especial' UNION
SELECT 3, 1, 'Palida, muy lupulada y de intenso sabor', 'Pale Ale' UNION
SELECT 3, 2, 'Trapense, de caracter fuerte. Afrutada, con colores que oscilan entre el bronce y el marron oscuro, alc. 6/8% vol.', 'Ale Belga' UNION
SELECT 4, 1, 'Stout, muy oscura de malta tostada', 'Cerveza Negra' UNION
SELECT 4, 2, 'Porter, muy fuerte y muy cremosa con matices a chocolate o café', 'Cerveza Negra' UNION
SELECT 5, 1, 'Rubia de maltas claras, ligero aroma a lúpulo, muy ligera. alc. 4% vol.', 'Lager Pilsen' UNION
SELECT 5, 2, 'Rubia dorada, con aromas malteados con notas a lúpulo, muy cremosa', 'Lager Especial' UNION
SELECT 6, 1, 'La lager con mas graduación alcoholica entre 6% y 7%, color cobrizo', 'Lager Extra' UNION
SELECT 6, 2, 'Palida, muy lupulada y de intenso sabor', 'Pale Ale' UNION
SELECT 7, 1, 'Palida, muy lupulada y de intenso sabor', 'Pale Ale' UNION
SELECT 7, 2, 'Rubia de maltas claras, ligero aroma a lúpulo, muy ligera. alc. 4% vol.', 'Lager Pilsen' UNION
SELECT 8, 1, 'Color bronceado con una espuma ligeramente tostada y con mucha persistencia. alc. 6% vol.', 'Abadia' UNION
SELECT 8, 2, '"Cerveza del verano", de sabor fresco y afrutado', 'Saison Belga' UNION
SELECT 9, 1, '"Cerveza del verano", de sabor fresco y afrutado', 'Saison Belga' UNION
SELECT 9, 2, 'La lager con mas graduación alcoholica entre 6% y 7%, color cobrizo', 'Lager Extra' UNION
SELECT 10, 1, 'Kölsh, de color pálido que madura en frío, suave y afrutada', 'Ale Alemana' UNION
SELECT 10, 2, 'Stout, muy oscura de malta tostada', 'Cerveza Negra' UNION
SELECT 11, 1, 'Rubia de maltas claras, ligero aroma a lúpulo, muy ligera. alc. 4% vol.', 'Lager Pilsen' UNION
SELECT 11, 2, 'Rubia dorada, con aromas malteados con notas a lúpulo, muy cremosa', 'Lager Especial' UNION
SELECT 12, 1, 'Trapense, de caracter fuerte. Afrutada, con colores que oscilan entre el bronce y el marron oscuro, alc. 6/8% vol.', 'Ale Belga' UNION
SELECT 12, 2, 'Porter, muy fuerte y muy cremosa con matices a chocolate o café', 'Cerveza Negra' UNION
SELECT 13, 1, 'Color bronceado con una espuma ligeramente tostada y con mucha persistencia. alc. 6% vol.', 'Abadia' UNION
SELECT 13, 2, '"Cerveza del verano", de sabor fresco y afrutado', 'Saison Belga' UNION
SELECT 14, 1, 'Color bronceado con una espuma ligeramente tostada y con mucha persistencia. alc. 6% vol.', 'Abadia' UNION
SELECT 14, 2, 'Rubia dorada, con aromas malteados con notas a lúpulo, muy cremosa', 'Lager Especial' UNION
SELECT 15, 1, 'Kölsh, de color pálido que madura en frío, suave y afrutada', 'Ale Alemana' UNION
SELECT 15, 2, 'Stout, muy oscura de malta tostada', 'Cerveza Negra'
GO

INSERT INTO Presentaciones (IdPresentacion_Pre, NombrePresentacion_Pre)
SELECT 1, 'Lata 473cc' UNION
SELECT 2, 'Lata 710cc' UNION
SELECT 3, 'Lata 1L' UNION
SELECT 4, 'Porrón 330cc' UNION
SELECT 5, 'Botella 710cc' UNION
SELECT 6, 'Botella 1L'
GO

INSERT INTO Cervezas (codCerveza_Ce, codMarca_Ce, codTipo_Ce, IdPresentacion_Ce, PrecioUnitarioCompra_Ce, PrecioUnitarioVenta_Ce, Stock_Ce, UrlImagen_Ce, Estado_Ce)
SELECT 1, 1, 1, 4, 875, 1300, 300, '~/Cervezas/1.jpg', 1 UNION
SELECT 2, 1, 1, 1, 800, 1350, 250, '~/Cervezas/2.jpg', 1 UNION
SELECT 3, 1, 2, 2, 970, 1410, 190, '~/Cervezas/3.jpg', 1 UNION
SELECT 4, 1, 2, 6, 1400, 2100, 130,  '~/Cervezas/4.jpg', 1 UNION
SELECT 5, 2, 1, 1, 760, 1200, 410, '~/Cervezas/5.jpg', 1 UNION
SELECT 6, 2, 1, 3, 1275, 1900, 115, '~/Cervezas/6.jpg', 1 UNION
SELECT 7, 2, 2, 1, 820, 1300, 215, '~/Cervezas/7.jpg', 1 UNION
SELECT 8, 2, 2, 5, 1100, 1630, 185, '~/Cervezas/8.jpg', 1 UNION
SELECT 9, 3, 1, 4, 800, 1210, 110, '~/Cervezas/9.jpg', 1 UNION
SELECT 10, 3, 2, 6, 1500, 2300, 45, '~/Cervezas/10.jpg', 1 UNION
SELECT 11, 4, 1, 2, 1030, 1700, 85, '~/Cervezas/11.jpg', 1 UNION
SELECT 12, 4, 2, 3, 1320, 2000, 90, '~/Cervezas/12.jpg', 1 UNION
SELECT 13, 5, 1, 1, 795, 1300, 30, '~/Cervezas/13.jpg', 1 UNION
SELECT 14, 5, 2, 2, 1000, 1500, 102, '~/Cervezas/14.jpg', 1 UNION
SELECT 15, 6, 1, 1, 900, 1380, 207, '~/Cervezas/15.jpg', 1 UNION
SELECT 16, 6, 2, 4, 910, 1420, 73, '~/Cervezas/16.jpg', 1 UNION
SELECT 17, 7, 1, 5, 1300, 1820, 41, '~/Cervezas/17.jpg', 1 UNION
SELECT 18, 7, 2, 6, 1350, 1980, 67, '~/Cervezas/18.jpg', 1 UNION
SELECT 19, 8, 1, 3, 1275, 2000, 160, '~/Cervezas/19.jpg', 1 UNION
SELECT 20, 8, 2, 2, 1025, 1400, 80, '~/Cervezas/20.jpg', 1 UNION
SELECT 21, 9, 1, 3, 1140, 1635, 112, '~/Cervezas/21.jpg', 1 UNION
SELECT 22, 9, 2, 1, 930, 1310, 90, '~/Cervezas/22.jpg', 1 UNION
SELECT 23, 10, 1, 5, 1240, 1700, 210, '~/Cervezas/23.jpg', 1 UNION
SELECT 24, 10, 2, 5, 1200, 1560, 170, '~/Cervezas/24.jpg', 1 UNION
SELECT 25, 11, 1, 2, 1070, 1610, 52, '~/Cervezas/25.jpg', 1 UNION
SELECT 26, 11, 2, 6, 1700, 2800, 35, '~/Cervezas/26.jpg', 1 UNION
SELECT 27, 12, 1, 3, 1210, 1700, 92, '~/Cervezas/27.jpg', 1 UNION
SELECT 28, 12, 2, 4, 940, 1480, 112, '~/Cervezas/28.jpg', 1 UNION
SELECT 29, 13, 1, 1, 950, 1610, 203, '~/Cervezas/29.jpg', 1 UNION 
SELECT 30, 13, 2, 4, 1010, 1710, 86, '~/Cervezas/30.jpg', 1 UNION
SELECT 31, 14, 1, 2, 1030, 1470, 57, '~/Cervezas/31.jpg', 1 UNION
SELECT 32, 14, 2, 3, 1120, 1530, 0, '~/Cervezas/32.jpg', 0 UNION
SELECT 33, 15, 1, 6, 1520, 2200, 0, '~/Cervezas/33.jpg', 0 UNION
SELECT 34, 15, 2, 1, 920, 1560, 42, '~/Cervezas/34.jpg', 1
GO

INSERT INTO Provincias (IdProvincia_Pr, NombreProvincia_Pr)
SELECT 1, 'Buenos Aires' UNION
SELECT 2, 'Cordoba' UNION
SELECT 3, 'Santa Fe' UNION
SELECT 4, 'Mendoza' UNION
SELECT 5, 'San Luis' UNION
SELECT 6, 'Chubut' UNION
SELECT 7, 'La Pampa' UNION
SELECT 8, 'Entre Ríos' UNION
SELECT 9, 'Corrientes' UNION
SELECT 10, 'Jujuy' UNION
SELECT 11, 'Tucuman' UNION
SELECT 12, 'Chaco' UNION
SELECT 13, 'Salta'
GO

INSERT INTO Localidades (IdLocalidad_Lo, IdProvincia_Lo, NombreLocalidad_Lo)
SELECT 1, 1, 'Tigre' UNION
SELECT 2, 1, 'San Fernando' UNION
SELECT 3, 1, 'San Isidro' UNION
SELECT 4, 2, 'Adamuz' UNION
SELECT 5, 2, 'Montoro' UNION
SELECT 6, 3, 'Recreo' UNION
SELECT 7, 3, 'Sauce Viejo' UNION
SELECT 8, 4, 'Godoy Cruz' UNION
SELECT 9, 4, 'San Carlos' UNION
SELECT 10, 5, 'Ayacucho' UNION
SELECT 11, 5, 'Junín' UNION
SELECT 12, 6, 'Rawson' UNION
SELECT 13, 6, 'Gaiman' UNION
SELECT 14, 7, 'Genereal Pico' UNION
SELECT 15, 7, 'Victorica' UNION
SELECT 16, 8, 'Salto' UNION
SELECT 17, 8, 'San Antonio' UNION
SELECT 18, 9, 'San Carlos' UNION
SELECT 19, 9, 'San Lorenzo' UNION
SELECT 20, 10, 'Ledesma' UNION
SELECT 21, 10, 'El Carmen' UNION
SELECT 22, 11, 'San Andrés' UNION
SELECT 23, 11, 'Santa Ana' UNION
SELECT 24, 12, 'Barranqueras' UNION
SELECT 25, 12, 'Charata' UNION
SELECT 26, 13, 'Cachi' UNION
SELECT 27, 13, 'Santa Rosa'
GO

INSERT INTO Pedidos (codMarca_Pe, Fecha_Pe, Total_Pe, Estado_Pe)
SELECT 1, '2023-04-21', 88500, 0 UNION
SELECT 3, '2023-05-15', 54000, 0 UNION
SELECT 8, '2023-07-03', 102250, 0 UNION
SELECT 14, '2024-05-12', 130800, 1 UNION
SELECT 2, '2023-08-27', 285600, 0 UNION
SELECT 9, '2023-10-15', 153100, 0 UNION
SELECT 12, '2023-11-26', 169300, 0 UNION
SELECT 4, '2024-01-05', 114600, 0 UNION
SELECT 10, '2024-02-04', 207600, 0 UNION
SELECT 7, '2024-03-17', 159500, 0
GO

INSERT INTO DetallePedidos (IdPedido_DP, codCerveza_DP, CantPedido_DP, PrecioUnitario_DP)
SELECT 1, 3, 50, 970 UNION
SELECT 1, 2, 50, 800 UNION
SELECT 2, 10, 20, 1500 UNION
SELECT 2, 9, 30, 800 UNION
SELECT 3, 19, 40, 1275 UNION
SELECT 3, 20, 50, 1025 UNION
SELECT 4, 31, 40, 1030 UNION
SELECT 4, 32, 80, 1120 UNION
SELECT 5, 6, 60, 1275 UNION
SELECT 5, 8, 80, 1100 UNION
SELECT 5, 5, 100, 760 UNION
SELECT 5, 7, 55, 820 UNION
SELECT 6, 21, 60, 1140 UNION
SELECT 6, 22, 45, 930 UNION
SELECT 7, 27, 70, 1210 UNION
SELECT 7, 28, 90, 940 UNION
SELECT 8, 11, 60, 1030 UNION
SELECT 8, 12, 40, 1320 UNION
SELECT 9, 23, 90, 1240 UNION
SELECT 9, 24, 80, 1200 UNION
SELECT 10, 17, 50, 1300 UNION
SELECT 10, 18, 70, 1350
GO

INSERT INTO Clientes (Dni_Cli, IdLocalidad_Cli, Nombre_Cli, Apellido_Cli, Legajo_Cli, Genero_Cli, Telefono_Cli, Contraseña_Cli, Estado_Cli)
SELECT '12345', 1, 'Juan', 'Pérez', '001', 'MASCULINO', '1111111111', 'contra1', 1 UNION
SELECT '09876', 3, 'María', 'Gómez', '002', 'FEMENINO', '2222222222', 'contra2', 1 UNION
SELECT '11223', 5, 'Carlos', 'López', '003', 'MASCULINO', '3333333333', 'contra3', 1 UNION
SELECT '51369', 2, 'Laura', 'Martínez', '004', 'FEMENINO', '4444444444', 'contra4', 1 UNION
SELECT '66778', 6, 'José', 'Fernández', '005', 'MASCULINO', '5555555555', 'contra5', 0 UNION
SELECT '77665', 2, 'Ana', 'Ramírez', '006', 'FEMENINO', '6666666666', 'contra6', 1 UNION
SELECT '88997', 3, 'Luis', 'Sánchez', '007', 'MASCULINO', '7777777777', 'contra7', 0 UNION
SELECT '99887', 1, 'Clara', 'García', '008', 'FEMENINO', '8888888888', 'contra8', 1 UNION
SELECT '11002', 2, 'Pedro', 'Rodríguez', '009', 'MASCULINO', '9999999999', 'contra9', 1 UNION
SELECT '22334', 5, 'Marta', 'Hernández', '010', 'FEMENINO', '1010101010', 'contra10', 1 UNION
SELECT '33445', 6, 'Jorge', 'Torres', '011', 'MASCULINO', '1212121212', 'contra11', 1 UNION
SELECT '44556', 7, 'Elena', 'Vázquez', '012', 'FEMENINO', '1313131313', 'contra12', 0 UNION
SELECT '55667', 8, 'Raúl', 'Álvarez', '013', 'MASCULINO', '1414141414', 'contra13', 1 UNION
SELECT '32784', 2, 'Isabel', 'Díaz', '014', 'FEMENINO', '1515151515', 'contra14', 1 UNION
SELECT '77889', 4, 'Lucas', 'Pratto', '015', 'MASCULINO', '1616161616', 'contra15', 1 
GO

INSERT INTO Trabajadores (Dni_Tr, IdLocalidad_Tr, Nombre_Tr, Apellido_Tr, Legajo_Tr, Genero_Tr, Telefono_Tr, Contraseña_Tr, FechaIngreso_Tr, Estado_Tr)
SELECT '34251', 2, 'Roberto', 'Morales', '016', 'MASCULINO', '1717171717', 'password16', '2020-01-01', 1 UNION
SELECT '04753', 4, 'Sara', 'Luna', '017', 'FEMENINO', '1818181818', 'password17', '2019-02-01', 1 UNION
SELECT '22213', 3, 'Enrique', 'Guzmán', '018', 'MASCULINO', '1919191919', 'password18', '2018-03-01', 1 UNION
SELECT '44321', 1, 'Natalia', 'Flores', '019', 'FEMENINO', '2020202020', 'password19', '2017-04-01', 0 UNION
SELECT '75689', 2, 'Andrés', 'Rojas', '020', 'MASCULINO', '2121212121', 'password20', '2016-05-01', 1 UNION
SELECT '84583', 1, 'Silvia', 'Castro', '021', 'FEMENINO', '2222222222', 'password21', '2015-06-01', 0 UNION
SELECT '98073', 3, 'Oscar', 'Pereyra', '022', 'MASCULINO', '2323232323', 'password22', '2014-07-01', 1 UNION
SELECT '22315', 1, 'Julia', 'Sosa', '023', 'FEMENINO', '2424242424', 'password23', '2013-08-01', 1 UNION
SELECT '12113', 1, 'Fernando', 'Aguilar', '024', 'MASCULINO', '2525252525', 'password24', '2012-09-01', 0 UNION
SELECT '76584', 2, 'Paula', 'Medina', '025', 'FEMENINO', '2626262626', 'password25', '2011-10-01', 1 UNION
SELECT '99088', 3, 'Esteban', 'Cabrera', '026', 'MASCULINO', '2727272727', 'password26', '2010-11-01', 1 UNION
SELECT '12312', 2, 'Verónica', 'Ruiz', '027', 'FEMENINO', '2828282828', 'password27', '2009-12-01', 1 UNION
SELECT '44675', 5, 'Gustavo', 'Mendoza', '028', 'MASCULINO', '2929292929', 'password28', '2008-01-01', 0 UNION
SELECT '87967', 1, 'Patricia', 'Ortiz', '029', 'FEMENINO', '3030303030', 'password29', '2007-02-01', 1 UNION
SELECT '23144', 1, 'Ignacio', 'Herrera', '030', 'MASCULINO', '3131313131', 'password30', '2006-03-01', 0
GO

INSERT INTO Ventas (Dni_Cli_Ve, Dni_Tr_Ve, TotalVenta_Ve, FechaVenta_Ve)
SELECT '12345', '34251', 4320, '2023-12-10' UNION
SELECT '09876', '34251', 1300, '2023-12-11' UNION
SELECT '11223', '34251', 7110, '2023-12-20' UNION
SELECT '51369', '44321', 5610, '2024-01-02' UNION
SELECT '66778', '75689', 5350, '2024-01-05' UNION
SELECT '77665', '84583', 3730, '2024-01-07' UNION
SELECT '88997', '98073', 3810, '2024-02-12' UNION
SELECT '99887', '22315', 3130, '2024-03-12' UNION
SELECT '11002', '12113', 5040, '2024-04-07' UNION
SELECT '22334', '76584', 4300, '2024-04-07'
GO

INSERT INTO DetalleVentas (codVenta_DV, codCerveza_DV, CantVenta_DV, PrecioUnitario_DV)
SELECT 1, 3, 2, 1410 UNION
SELECT 1, 14, 1, 1500 UNION
SELECT 2, 13, 1, 1300 UNION
SELECT 3, 5, 3, 1200 UNION
SELECT 3, 33, 1, 2200 UNION
SELECT 3, 22, 1, 1310 UNION
SELECT 4, 25, 1, 1610 UNION
SELECT 4, 19, 2, 2000 UNION
SELECT 5, 30, 1, 1710 UNION
SELECT 5, 17, 2, 1820 UNION
SELECT 6, 9, 2, 1210 UNION
SELECT 6, 22, 1, 1310 UNION
SELECT 7, 3, 1, 1410 UNION
SELECT 7, 5, 2, 1200 UNION
SELECT 8, 16, 1, 1420 UNION
SELECT 8, 30, 1, 1710 UNION
SELECT 9, 17, 1, 1820 UNION
SELECT 9, 25, 2, 1610 UNION
SELECT 10, 13, 1, 1300 UNION
SELECT 10, 14, 2, 1500
GO


--CONSULTAS

--Trabajadores activos
SELECT Trabajadores.Nombre_Tr + ' ' + Trabajadores.Apellido_Tr AS [Trabajador/a], Trabajadores.Legajo_Tr, Trabajadores.FechaIngreso_Tr
FROM Trabajadores
WHERE Estado_Tr = 1
GO

--Empleados con sus ventas
SELECT Trabajadores.Nombre_Tr + ' ' + Trabajadores.Apellido_Tr AS [Trabajador/a], SUM(1) AS [VENTAS]
FROM Trabajadores INNER JOIN Ventas
ON Trabajadores.Dni_Tr = Ventas.Dni_Tr_Ve
GROUP BY Trabajadores.Nombre_Tr + ' ' + Trabajadores.Apellido_Tr
GO

--Ventas por localidad
SELECT Localidades.NombreLocalidad_Lo AS Localidad, SUM(1) AS Ventas
FROM Localidades INNER JOIN Clientes
ON Localidades.IdLocalidad_Lo = Clientes.IdLocalidad_Cli INNER JOIN Ventas
ON Clientes.Dni_Cli = Ventas.Dni_Cli_Ve
GROUP BY Localidades.NombreLocalidad_Lo
GO

--Margen de precio compra/venta de cada cerveza de mayor a menor
SELECT Cervezas.codCerveza_Ce, Tipos_Cerveza.NombreTipo_TC, Tipos_Cerveza.Descripcion_TC, Presentaciones.NombrePresentacion_Pre,  Cervezas.PrecioUnitarioVenta_Ce - Cervezas.PrecioUnitarioCompra_Ce AS MARGEN
FROM Cervezas INNER JOIN Presentaciones
ON Cervezas.IdPresentacion_Ce = Presentaciones.IdPresentacion_Pre INNER JOIN Tipos_Cerveza
ON Cervezas.codMarca_Ce = Tipos_Cerveza.codMarca_TC AND Cervezas.codTipo_Ce = Tipos_Cerveza.codTipo_TC
ORDER BY MARGEN desc
GO

--Stock de Cervezas
SELECT Cervezas.codCerveza_Ce, Tipos_Cerveza.NombreTipo_TC, Tipos_Cerveza.Descripcion_TC, Presentaciones.NombrePresentacion_Pre, 'Cantidad de Stock' =
CASE
	WHEN Stock_Ce = 0 THEN 'Sin Stock'
	WHEN Stock_Ce < 20  AND Stock_Ce > 0 THEN 'Poco Stock'
	WHEN Stock_Ce < 60 AND Stock_Ce >= 20 THEN 'Stock Moderado'
	ELSE 'Gran cantidad de Stock'
	END
FROM Cervezas INNER JOIN Presentaciones
ON Cervezas.IdPresentacion_Ce = Presentaciones.IdPresentacion_Pre INNER JOIN Tipos_Cerveza
ON Cervezas.codMarca_Ce = Tipos_Cerveza.codMarca_TC and Cervezas.codTipo_Ce = Tipos_Cerveza.codTipo_TC
GO


--Codigo de Marca de Cerveza más vendida con Vista
CREATE VIEW View_VentasTotalesxCerveza
AS
SELECT SUM(CantVenta_DV) AS Total, codCerveza_Ce
FROM DetalleVentas INNER JOIN Cervezas
ON DetalleVentas.codCerveza_DV = Cervezas.codCerveza_Ce
GROUP BY codCerveza_Ce
GO

SELECT View_VentasTotalesxCerveza.Total AS MayorCantidad, View_VentasTotalesxCerveza.codCerveza_Ce, codMarca_Ce
FROM View_VentasTotalesxCerveza INNER JOIN DetalleVentas
ON View_VentasTotalesxCerveza.codCerveza_Ce = DetalleVentas.codCerveza_DV INNER JOIN Cervezas
ON DetalleVentas.codCerveza_DV = Cervezas.codCerveza_Ce
WHERE Total = (SELECT MAX(Total) FROM View_VentasTotalesxCerveza)
GROUP BY View_VentasTotalesxCerveza.Total, View_VentasTotalesxCerveza.codCerveza_Ce, codMarca_Ce
GO

--Ver todas las restricciones CHECK, UNIQUE, PRIMARY KEY y FOREIGN KEY de la base
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
GO

--PROCEDIMIENTOS

CREATE PROCEDURE sp_AgregarCliente
@DNI CHAR(10),
@Localidad char(4),
@Nombre VARCHAR(25),
@Apellido VARCHAR(25),
@Legajo VARCHAR(5),
@Genero VARCHAR(10),
@Telefono VARCHAR(13),
@Contrasenia VARCHAR(15)
AS
BEGIN
INSERT INTO Clientes(DNI_Cli, IdLocalidad_Cli, Nombre_Cli, Apellido_Cli, Legajo_Cli, Genero_Cli, Telefono_Cli, Contraseña_Cli)
VALUES(@DNI, @Localidad, @Nombre, @Apellido, @Legajo, @Genero, @Telefono, @Contrasenia)
END
GO

CREATE PROCEDURE sp_DarBajaCliente
@DNICliente CHAR(10)
AS
BEGIN
UPDATE Clientes
SET Estado_Cli = 0
WHERE DNI_Cli = @DNICliente;
END
GO

CREATE PROCEDURE Sp_EditarClientes
@DNI CHAR(10),
@Localidad char(4),
@Nombre VARCHAR(25),
@Apellido VARCHAR(25),
@Legajo VARCHAR(5),
@Genero VARCHAR(10),
@Telefono VARCHAR(13),
@Contrasenia VARCHAR(15)
AS
BEGIN
UPDATE Clientes
SET Nombre_Cli = @Nombre,
IdLocalidad_Cli = @Localidad,
Apellido_Cli = @Apellido,
Legajo_Cli = @Legajo,
Genero_Cli = @Genero,
Telefono_Cli = @Telefono,
Contraseña_Cli = @Contrasenia
WHERE DNI_Cli = @DNI;
END
GO

CREATE PROCEDURE sp_AgregarTrabajador
@DNI CHAR(10),
@Localidad char(4),
@Nombre VARCHAR(25),
@Apellido VARCHAR(25),
@Legajo VARCHAR(5),
@Genero VARCHAR(10),
@Telefono VARCHAR(13),
@Contrasenia VARCHAR(25),
@FechaIngreso DATETIME
AS
BEGIN
INSERT INTO Trabajadores(DNI_Tr, IdLocalidad_Tr, Nombre_Tr, Apellido_Tr, Legajo_Tr, Genero_Tr, Telefono_Tr, Contraseña_Tr, FechaIngreso_Tr)
VALUES(@DNI, @Localidad, @Nombre, @Apellido, @Legajo, @Genero, @Telefono, @Contrasenia, @FechaIngreso)
END
GO

CREATE PROCEDURE sp_DarBajaTrabajador
@DNITrabajador CHAR(10)
AS
BEGIN
UPDATE Trabajadores
SET Estado_Tr = 0  
WHERE DNI_Tr = @DNITrabajador
END
GO

CREATE PROCEDURE Sp_EditarTrabajador
@DNI CHAR(10),
@Localidad char(4),
@Nombre VARCHAR(25),
@Apellido VARCHAR(25),
@Legajo VARCHAR(5),
@Genero VARCHAR(10),
@Telefono VARCHAR(13),
@Contrasenia VARCHAR(25),
@FechaIngreso DATE
AS
BEGIN
UPDATE Trabajadores
SET Nombre_Tr = @Nombre,
IdLocalidad_Tr = @Localidad,
Apellido_Tr = @Apellido,
Legajo_Tr = @Legajo,
Genero_Tr = @Genero,
Telefono_Tr = @Telefono,
Contraseña_Tr = @Contrasenia,
FechaIngreso_Tr = @FechaIngreso
WHERE DNI_Tr = @DNI
END
GO


CREATE PROCEDURE sp_AgregarCerveza
@CodCerverza char(10),
@CodMarca char(10),
@CodTipo char(10),
@IdPresentacion char(4),
@PrecioUnitarioCompra DECIMAL(8, 2),
@PrecioUnitarioVenta DECIMAL(8, 2),
@Stock INT,
@URLImagenCerveza VARCHAR(100),
@Estado bit
AS
BEGIN
INSERT INTO Cervezas (codCerveza_Ce, codMarca_Ce, codTipo_Ce, IdPresentacion_Ce, PrecioUnitarioCompra_Ce, PrecioUnitarioVenta_Ce, Stock_Ce, UrlImagen_Ce, Estado_Ce)
VALUES (@CodCerverza, @CodMarca,  @CodTipo, @IdPresentacion, @PrecioUnitarioCompra, @PrecioUnitarioVenta, @Stock, @URLImagenCerveza, @Estado)
END
GO

CREATE PROCEDURE sp_DarDeBajaCerveza
    @CodCerveza char(4)
AS
BEGIN
    UPDATE Cervezas
    SET Estado_Ce = 0  
    WHERE codCerveza_Ce = @CodCerveza;
END
GO

CREATE PROCEDURE sp_DarDeAltaCerveza
    @CodCerveza char(4)
AS
BEGIN
    UPDATE Cervezas
    SET Estado_Ce = 1  
    WHERE codCerveza_Ce = @CodCerveza;
END
GO

CREATE PROCEDURE sp_EditarCervezas
@CodCerveza char(10),
@CodMarca char(10),
@CodTipo char(10),
@IdPresentacion char(4),
@PrecioUnitarioCompra DECIMAL(8, 2),
@PrecioUnitarioVenta DECIMAL(8, 2),
@Stock INT,
@URLImagenCerveza VARCHAR(100),
@Estado bit
AS
BEGIN
    UPDATE Cervezas
    SET codMarca_Ce = @CodMarca,
        codTipo_Ce = @CodTipo,
		PrecioUnitarioCompra_Ce = @PrecioUnitarioCompra,
        PrecioUnitarioVenta_Ce = @PrecioUnitarioVenta,
		Stock_Ce =  @Stock,
        UrlImagen_Ce = @URLImagenCerveza,
		Estado_Ce = @Estado
    WHERE codCerveza_Ce = @CodCerveza;
END
GO


CREATE PROCEDURE sp_PedidoEntregado
@IdPedido char(4)
AS
BEGIN
UPDATE Pedidos
SET Estado_Pe = 0
WHERE IdPedido_Pe = @IdPedido
END
GO

--TRIGGERS

--Despues de que se haga un insert en DetalleVentas resta el stock que se vendió de cada cerveza
CREATE TRIGGER tr_ActualizacionStockVenta
ON DetalleVentas
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
IF ((SELECT Stock_Ce FROM Cervezas WHERE Cervezas.codCerveza_Ce = (SELECT codCerveza_DV FROM inserted)) - (SELECT CantVenta_DV FROM inserted) >= 0)
UPDATE Cervezas set Stock_Ce = Stock_Ce - (SELECT CantVenta_DV FROM inserted)
WHERE Cervezas.codCerveza_Ce = (SELECT codCerveza_DV FROM inserted)
ELSE
ROLLBACK TRANSACTION
END
GO

--Despues de que se haga un insert en DetalleVentas actualiza el total de la venta según la cantidad vendida y el precio de la unidad vendida
CREATE TRIGGER tr_TotalVenta
ON DetalleVentas
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
UPDATE Ventas set TotalVenta_Ve = TotalVenta_Ve + (SELECT inserted.CantVenta_DV * inserted.PrecioUnitario_DV FROM inserted)
WHERE Ventas.codVenta_Ve = (SELECT codVenta_DV FROM inserted)
END
GO

--Despues de actualizar Cervezas si se actualizó el stock y pasa a ser 0 deshabilita la cerveza
CREATE TRIGGER tr_DesactivarCervezaSinStock
ON Cervezas
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
IF UPDATE(Stock_Ce) AND (SELECT Stock_Ce FROM inserted) = 0
UPDATE Cervezas set Estado_Ce = 0
WHERE Cervezas.codCerveza_Ce = (SELECT codCerveza_Ce FROM inserted)
END
GO

--Despues de actualizar el stock de una cerveza que tenía stock 0 la reactiva
CREATE TRIGGER tr_ReactivarCerveza
ON Cervezas
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
IF UPDATE(Stock_Ce) AND (SELECT Stock_Ce FROM deleted) = 0
UPDATE Cervezas set Estado_Ce = 1
WHERE Cervezas.codCerveza_Ce = (SELECT codCerveza_Ce FROM inserted)
END
GO

--No te deja borrar ni modificar las tablas, tira un mensaje de error
CREATE TRIGGER tr_Seguridad
ON DATABASE FOR drop_table, alter_table
AS BEGIN
RAISERROR ('No tienes permitido borrar ni modificar las tablas', 16, 1)
ROLLBACK TRANSACTION
END
GO

