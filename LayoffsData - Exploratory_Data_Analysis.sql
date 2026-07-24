-- Exploratory Data Analysis

SELECT *
FROM layoff_staging2;


SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`, 1, 7) AS `MONTH` , SUM(total_laid_off)
FROM layoff_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH` , SUM(total_laid_off) AS monthly_total_off
FROM layoff_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 ASC
)
SELECT `MONTH`, monthly_total_off, SUM(monthly_total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- Ranking company, year and total_laid_off

SELECT company, Year(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, Year(`date`)
ORDER BY 3 DESC;

WITH Yearly_Ranking (company, years, Yearly_laid_off) AS
(
SELECT company, YEAR(`date`) , SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, Year(`date`)
ORDER BY 3 ASC
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY Yearly_laid_off DESC) AS Ranking
FROM Yearly_Ranking
WHERE Yearly_laid_off IS NOT NULL and years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
where Ranking <=5
;




