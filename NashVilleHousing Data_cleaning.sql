/* Cleaning data in SQL Queries

*/

-- Standaraize date format

SELECT SaleDate,CAST(SaleDate as date) 
FROM NashVilleHousing

ALTER TABLE NashVilleHousing
ADD Converted_date  date;

UPDATE NashVilleHousing
SET converted_date=CAST(SaleDate as date);


--Populate Property address

SELECT*
FROM NashVilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashVilleHousing a
JOIN NashVilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Updating the table

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashVilleHousing a
JOIN NashVilleHousing b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--- SPILT COlumns Into Address and City
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as city

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.NashvilleHousing

--USing Parsename and Replace Function Which uses Comma and Dot

SELECT OwnerAddress,PARSENAME(REPLACE( OwnerAddress,',','.'),1) ,
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM NashVilleHousing

--Updating the tables

ALTER TABLE NashVilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashVilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashVilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashVilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashVilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashVilleHousing
SET OwnerSplitState=PARSENAME(REPLACE( OwnerAddress,',','.'),1)


SELECT*
FROM NashVilleHousing


--Change Y and N to Yes and NO in sold as vaccant


SELECT SoldAsVacant,COUNT(SoldAsVacant)
FROM NashVilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

-- USING CASE Statements

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant ='N' THEN 'No'
ELSE 
SoldAsVacant
END
FROM NashVilleHousing

-- Update The tables

UPDATE NashVilleHousing
SET SoldAsVacant=CASE
WHEN SoldAsVacant='Y' THEN 'Yes'
WHEN SoldAsVacant ='N' THEN 'No'
ELSE 
SoldAsVacant
END


-- Remove Duplicates

-- First Finding the Duplicates Values 

SELECT ParcelID,PropertyAddress,SalePrice,LegalReference,COUNT(*)
FROM NashVilleHousing
GROUP BY  ParcelID,PropertyAddress,SalePrice,LegalReference
HAVING COUNT(*)>1

-- Deleting By Using the CTE Clause and Window Function 

WITH ROWNUMCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, LegalReference ORDER BY UniqueID) AS Row_number 
    FROM NashVilleHousing
)
SELECT * 
FROM ROWNUMCTE
WHERE Row_number>1 ;


-- Delete Unused Columns

ALTER TABLE NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


 SELECT *
 FROM NashVilleHousing
