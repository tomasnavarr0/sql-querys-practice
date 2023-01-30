
CREATE TABLE fabricante (
  id INT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto (
  id INT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio INT NOT NULL,
  id_fabricante INT NOT NULL,
  FOREIGN KEY (id_fabricante) REFERENCES fabricante(id)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');

INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

/* Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.*/
SELECT * FROM producto
SELECT * FROM fabricante

SELECT producto.nombre,precio,fabricante.nombre
FROM producto
INNER JOIN fabricante ON id_fabricante=fabricante.id

/*Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
SELECT nombre,precio 
FROM producto
WHERE id_fabricante=(SELECT id FROM fabricante WHERE nombre='Lenovo')

/* Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo*/
SELECT * 
FROM producto 
WHERE precio=(SELECT TOP 1 precio
	FROM producto 
	WHERE id_fabricante=(SELECT id 
							FROM fabricante 
							WHERE nombre='Lenovo')
	ORDER BY precio DESC)

/*Lista el nombre del producto más caro del fabricante Lenovo.*/
SELECT TOP 1(precio),nombre 
FROM producto 
WHERE id_fabricante=(SELECT id FROM fabricante WHERE nombre='Lenovo')
ORDER BY precio DESC

/* Lista el nombre del producto más barato del fabricante Hewlett-Packard.*/ 
SELECT TOP 1 (precio),nombre 
FROM producto 
WHERE id_fabricante=(SELECT id FROM fabricante WHERE nombre='Hewlett-Packard')
ORDER BY precio ASC

/* Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo*/

SELECT * 
FROM producto
WHERE precio>(SELECT TOP 1(precio) 
				FROM producto 
				WHERE id_fabricante=(SELECT id 
										FROM fabricante 
										WHERE nombre='Lenovo')
				ORDER BY precio DESC)

/* Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.*/
SELECT *
FROM producto
WHERE precio>(SELECT AVG(precio) 
				FROM producto 
				WHERE id_fabricante=(SELECT id 
										FROM fabricante 
										WHERE nombre='Asus')

/* Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT*/
SELECT TOP 1(precio),nombre 
FROM producto
ORDER BY precio DESC

/* Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).*/
SELECT nombre
FROM fabricante 
WHERE id IN (SELECT id_fabricante FROM producto)

/* Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).*/
SELECT nombre
FROM fabricante 
WHERE id NOT IN (SELECT id_fabricante FROM producto)

/* Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).*/
SELECT nombre 
FROM producto 
WHERE EXISTS (SELECT id_fabricante FROM producto)

/*Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS)*/
SELECT nombre 
FROM producto 
WHERE NOT EXISTS (SELECT id_fabricante FROM producto)

/* Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de productos que el fabricante Lenovo.*/ 

SELECT COUNT(producto.id_fabricante) AS CantidadProd,fabricante.nombre
FROM producto
INNER JOIN fabricante ON id_fabricante=fabricante.id
GROUP by id_fabricante,fabricante.nombre
HAVING COUNT(producto.id_fabricante)>=(SELECT id FROM fabricante WHERE nombre='Lenovo')

