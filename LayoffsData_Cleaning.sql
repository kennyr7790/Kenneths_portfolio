-- Data Cleaning Project

SELECT * 
FROM layoffs;

-- 1 Remove Duplicates
-- 2 Standarize The Data
-- 3 Null Values or Blank Values
-- 4 Remove Any Columns


CREATE TABLE layoff_Staging
LIKE layoffs;

SELECT *
FROM layoff_Staging;

INSERT layoff_Staging
SELECT *
FROM layoffs;

-- Duplicates REMOVED

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoff_Staging
)
Select *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoff_Staging
WHERE company = 'casper';


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoff_Staging2
where row_num >1;


INSERT INTO layoff_Staging2
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoff_Staging;

DELETE
FROM layoff_Staging2
where row_num >1;

SELECT *
FROM layoff_Staging2;

-- Standardizing Data

SELECT DISTINCT(TRIM(company))
FROM layoff_Staging2;

UPDATE layoff_Staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoff_Staging2;

UPDATE layoff_Staging2
SET industry = 'Crypto'
WHERE industry = 'Crypto%';

SELECT DISTINCT country
FROM layoff_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET Country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Updating Date column from text to date
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_Staging2;

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoff_Staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoff_Staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoff_Staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoff_Staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoff_Staging2;

UPDATE layoff_Staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;
    

DELETE
FROM layoff_Staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Removing row_num Column
SELECT *
FROM layoff_Staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;







