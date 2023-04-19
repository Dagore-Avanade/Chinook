-- Insertar el álbum "El espíritu del vino" del grupo "Héroes del Silencio". 
-- Y comprobar que se ha dado de alta correctamente.

INSERT INTO [Artist] ([Name]) VALUES ('Héroes del Silencio');
INSERT INTO [Album]
	([Title], [ArtistId])
VALUES
	('El espíritu del vino', (SELECT [ArtistId] FROM [Artist] WHERE [Name] LIKE 'Héroes del Silencio'));

-- Insertar el álbum "Ante todo mucha calma" del grupo "Siniestro Total". 
-- Comprobar que se ha dado de alta correctamente.

INSERT INTO [Artist] ([Name]) VALUES ('Siniestro Total');
INSERT INTO [Album]
	([Title], [ArtistId])
VALUES
	('Ante todo mucha calma', (SELECT [ArtistId] FROM [Artist] WHERE [Name] LIKE 'Siniestro Total'));

-- Insertar la canción "El camino del exceso", de tipo de medio MPEG audio file, 5 minutos de duración, y precio 0'99.
-- Comprobar que se ha dado de alta correctamente.

INSERT INTO [Track]
	([Name], [MediaTypeId], [Milliseconds], [UnitPrice])
VALUES
	(
		'El camino del exceso',
		(SELECT TOP (1) [MediaTypeId] FROM [MediaType] WHERE [Name] LIKE 'MPEG audio file'),
		(5 * 60000),
		0.99
	);

-- Obtener el número total de canciones (tengan o no álbum asociado).

SELECT
	COUNT([TrackId]) [Count]
FROM [Track];

-- Obtener el listado de artistas y álbumes. En caso de no poseer ningún álbum, el título será "----- NO ALBUM -----".

SELECT
	[Name],
	ISNULL([Title], '----- NO ALBUM -----')
FROM [Artist]
LEFT JOIN [Album]
	ON [Artist].[ArtistId] = [Album].[ArtistId];

-- ¿Cuál es el precio más caro entre todas las canciones?

SELECT
	MAX([UnitPrice]) [Max]
FROM [Track];

-- Obtener el listado de compositores (Track.Composer) existente (No obtener los nulos).

SELECT DISTINCT
	[Composer]
FROM [Track]
WHERE [Composer] IS NOT NULL;

-- Obtener el número de compositores (Track.Composer) existente (No obtener los nulos).

SELECT
	COUNT(DISTINCT [Composer])
FROM [Track]
WHERE [Composer] IS NOT NULL;

-- Obtener artista, álbum, y cada canción del álbum.
-- Ordenados por artista, álbum y canción.

SELECT
	[Artist].[Name] [Name],
	[Album].[Title] [Album],
	[Track].[Name] [Track]
FROM [Artist]
JOIN [Album]
	ON [Artist].[ArtistId] = [Album].[ArtistId]
JOIN [Track]
	ON [Album].[AlbumId] = [Track].[AlbumId]
ORDER BY [Name], [Album], [Track];

-- ¿Aparecen los álbumes de Héroes del Silencio y Siniestro Total? ¿Por qué no? 
-- En caso negativo, hacer que aparezcan también en la consulta sin realizar cambios en ningún registro.  

SELECT
	[Artist].[Name] [Artist],
	[Album].[Title] [Album],
	[Track].[Name] [Track]
FROM [Artist]
LEFT JOIN [Album]
	ON [Artist].[ArtistId] = [Album].[ArtistId]
LEFT JOIN [Track]
	ON [Album].[AlbumId] = [Track].[AlbumId]
ORDER BY [Artist], [Album], [Track];

-- Obtener artista, álbum, y cada canción del álbum, junto con su medio digital y su género. 
-- Ordenados por artista, álbum y canción.
-- ¿Aparecen los álbumes de Héroes del Silencio y Siniestro Total? ¿Por qué no? 
-- En caso negativo, hacer que aparezcan también en la consulta sin realizar cambios en ningún registro.

SELECT
	[Artist].[Name] [Artist],
	[Album].[Title] [Album],
	[Track].[Name] [Track],
	[MediaType].[Name] [MediaType],
	[Genre].[Name] [Genre]
FROM [Artist]
LEFT JOIN [Album]
	ON [Artist].[ArtistId] = [Album].[ArtistId]
LEFT JOIN [Track]
	ON [Album].[AlbumId] = [Track].[AlbumId]
LEFT JOIN [MediaType]
	ON [Track].[MediaTypeId] = [MediaType].[MediaTypeId]
LEFT JOIN [Genre]
	ON [Track].[GenreId] = [Genre].[GenreId]
ORDER BY [Artist], [Album], [Track];


-- ¿Por qué no estaba apareciendo ninguna canción de Héroes del Silencio? 
-- Arregla los datos para que aparezca la canción que dimos de alta unos pasos atrás, 
-- que parece que su registro no posee relación con su correspondiente álbum.
-- Ya de paso, aprovechemos para indicar que su género musical es el Rock And Roll.
-- Una vez arreglados los datos, lanza la query anterior y comprueba si ya aparece la canción.

UPDATE [Track]
SET
	[AlbumId] = (SELECT [AlbumId] FROM [Album] WHERE [Title] LIKE 'El espíritu del vino'),
	[GenreId] = (SELECT [GenreId] FROM [Genre] WHERE [Name] LIKE 'Rock And Roll')
WHERE [Name] LIKE 'El camino del exceso';

-- Obtener todos los artistas y género musical, siendo este último rock o rock and roll (GenreId 1 y 5 respectivamente).
-- Ordenados por artista, álbum y género.

SELECT DISTINCT
	[Artist].[Name] [Artist],
	[Genre].[Name] [Genre]
FROM [Artist]
LEFT JOIN [Album]
	ON [Artist].[ArtistId] = [Album].[ArtistId]
LEFT JOIN [Track]
	ON [Album].[AlbumId] = [Track].[AlbumId]
LEFT JOIN [MediaType]
	ON [Track].[MediaTypeId] = [MediaType].[MediaTypeId]
LEFT JOIN [Genre]
	ON [Track].[GenreId] = [Genre].[GenreId]
WHERE [Genre].[GenreId] = 1 OR [Genre].[GenreId] = 5
ORDER BY [Artist], [Genre].[Name];

-- Obtener los distintos tipos de géneros que existen y cuántas canciones hay de cada uno.

SELECT
	[Genre].[Name] [Name],
	COUNT([Genre].[GenreId]) [Count]
FROM [Genre]
JOIN [Track]
	ON [Genre].[GenreId] = [Track].[GenreId]
GROUP BY [Genre].[Name];

-- Obtener todas las canciones de Guns N' Roses (ArtistId: 88) cuya duración sea mayor o igual a 5 minutos. 
-- Mostrar el álbum al que pertenece.

SELECT
	[Track].[Name] [Name],
	[Album].[Title] [Album]
FROM [Track]
JOIN [Album]
	ON [Track].[AlbumId] = [Album].[AlbumId]
WHERE [Album].[ArtistId] = 88 AND [Track].[Milliseconds] >= (5 * 60000);

-- Obtener todas las canciones cuyo precio sea el más caro. Mostrar su artista, álbum, canción y precio.

SELECT
	[Artist].[Name] [Artist],
	[Album].[Title] [Album],
	[Track].[Name] [Track],
	[Track].[UnitPrice] [Price]
FROM [Track]
JOIN [Album]
	ON [Track].[AlbumId] = [Album].[AlbumId]
JOIN [Artist]
	ON [Album].[ArtistId] = [Artist].[ArtistId]
WHERE [Track].[UnitPrice] = (SELECT MAX([Track].[UnitPrice]) FROM [Track]);

-- Obtener artista, álbum, número total de canciones del álbum, y duración en minutos del álbum.

SELECT
	[Artist].[Name] [Artist],
	[Album].[Title] [Album],
	COUNT([Track].[TrackId]) [Tracks],
	(SUM([Track].[Milliseconds]) / 60000) [Duration (min)]
FROM [Track]
JOIN [Album]
	ON [Track].[AlbumId] = [Album].[AlbumId]
JOIN [Artist]
	ON [Album].[ArtistId] = [Artist].[ArtistId]
GROUP BY [Artist].[Name], [Album].[Title]
ORDER BY [Artist].[Name], [Album].[Title];

-- Obtener artista, álbum, número total de canciones del álbum, y duración en minutos del álbum
-- pero sólo de aquellos con más de 10 canciones por álbum, y duración por álbum mayor o igual que 1 hora.

SELECT
	[Artist].[Name] [Artist],
	[Album].[Title] [Album],
	COUNT([Track].[TrackId]) [Tracks],
	(SUM([Track].[Milliseconds]) / 60000) [Duration (min)]
FROM [Track]
JOIN [Album]
	ON [Track].[AlbumId] = [Album].[AlbumId]
JOIN [Artist]
	ON [Album].[ArtistId] = [Artist].[ArtistId]
GROUP BY [Artist].[Name], [Album].[Title]
HAVING COUNT([Track].[TrackId]) > 10 AND (SUM([Track].[Milliseconds]) / 60000) >= 60
ORDER BY [Artist].[Name], [Album].[Title];

-- Mostrar nombre, apellidos, ciudad y país de cada cliente junto con 
-- el total de cada pedido y el número total de canciones de cada pedido.
-- No tomaremos en cuenta el campo Quantity.

SELECT
	[FirstName],
	[LastName],
	[City],
	[Country],
	[Invoice].[Total] [Total],
	COUNT([InvoiceLine].[InvoiceLineId]) [Count]
FROM [Customer]
JOIN [Invoice]
	ON [Customer].[CustomerId] = [Invoice].[CustomerId]
JOIN [InvoiceLine]
	ON [Invoice].[InvoiceId] = [InvoiceLine].[InvoiceId]
GROUP BY 
	[FirstName],
	[LastName],
	[City],
	[Country],
	[Invoice].[Total];
