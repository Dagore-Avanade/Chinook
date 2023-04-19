-- Ejecutar las siguientes 4 actualizaciones sobre la tabla de Invoice:
UPDATE Invoice 
   SET InvoiceDate = '2009-01-06 14:30:00.000'
 WHERE InvoiceId   = 4;

UPDATE Invoice 
   SET InvoiceDate = '2009-03-04 09:45:00.000'
 WHERE InvoiceId   = 14;


UPDATE Invoice 
   SET InvoiceDate = '2009-03-04 17:20:00.000'
 WHERE InvoiceId   = 15;

UPDATE Invoice 
   SET InvoiceDate = '2009-03-05 11:10:00.000'
 WHERE InvoiceId   = 16;
 
 
-- Obtener todos los pedidos realizados antes del 04/03/2009 (inclusive).

 SELECT
	*
FROM [Invoice]
WHERE [Invoice].[InvoiceDate] <= '2009-03-04 00:00:00.000';

--Obtener nombre y apellidos del cliente, junto con la fecha de cada factura y su coste, de todo el año 2010

SELECT
	[Customer].[CustomerId],
	[Customer].[FirstName],
	[Customer].[LastName],
	[Invoice].[InvoiceDate],
	[Invoice].[Total]
FROM [Invoice]
JOIN [Customer]
	ON [Invoice].[CustomerId] = [Customer].[CustomerId]
WHERE [Invoice].[InvoiceDate] >= '2010-01-01 00:00:00.000' AND [Invoice].[InvoiceDate] <= '2010-12-31 23:59:59.999'
ORDER BY [CustomerId];

--Obtener el número de pedidos y la suma de sus facturas, por países del año 2010

SELECT
	[Country],
	COUNT([InvoiceId]) [Count],
	SUM([Total]) [Total]
FROM [Invoice]
JOIN [Customer]
	ON [Invoice].[CustomerId] = [Customer].[CustomerId]
WHERE [Invoice].[InvoiceDate] >= '2010-01-01 00:00:00.000' AND [Invoice].[InvoiceDate] <= '2010-12-31 23:59:59.999'
GROUP BY [Country];
