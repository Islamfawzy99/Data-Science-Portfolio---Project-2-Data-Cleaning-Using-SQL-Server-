-- Taking a gander at the whole table 

SELECT *
FROM HousingMarket

-- Date Formatting

SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM HousingMarket

UPDATE HousingMarket
SET SaleDate= CONVERT(Date,SaleDate)

	ALTER TABLE HousingMarket 
	ADD SaleDateConverted Date;

	UPDATE HousingMarket
	SET SaleDateConverted = CONVERT(Date,SaleDate)

--Replacing null values within PropertyAddress column 

SELECT *                  -- Note: Exploring the data showed that ParcelID is going to be the same as the PropertyAddress 
FROM HousingMarket

SELECT TableA.ParcelID,
       TableA.PropertyAddress,
	   TableB.ParcelID,
	   TableB.PropertyAddress,
	   ISNULL(TableA.PropertyAddress,TableB.PropertyAddress)     
FROM HousingMarket TableA
JOIN HousingMarket TableB
ON TableA.ParcelID = TableB.ParcelID AND TableA.[UniqueID ] != TableB.[UniqueID ]
WHERE TableA.PropertyAddress IS NULL

UPDATE TableA
SET PropertyAddress = ISNULL(TableA.PropertyAddress,TableB.PropertyAddress)
FROM HousingMarket TableA
JOIN HousingMarket TableB
ON TableA.ParcelID = TableB.ParcelID AND TableA.[UniqueID ] != TableB.[UniqueID ]
WHERE TableA.PropertyAddress IS NULL

-- Splittig the Property Address Column into 2 columns [Address] and [City]

SELECT 
      SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress) -1) AS Adress, 
	  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) AS City
FROM HousingMarket

ALTER TABLE HousingMarket 
ADD PropertySplitAddress NVARCHAR(300);

UPDATE HousingMarket
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress) -1) 


ALTER TABLE HousingMarket 
ADD PropertySplitCity NVARCHAR(300);

UPDATE HousingMarket
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) 

-- Splittig the Owner Address Column into 3 columns [Address] , [City] and [State]

SELECT 
      PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	  PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	  PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM HousingMarket

ALTER TABLE HousingMarket 
ADD OwnerSplitAddress NVARCHAR(300);

UPDATE HousingMarket
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE HousingMarket 
ADD OwnerSplitCity NVARCHAR(300);

UPDATE HousingMarket
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE HousingMarket 
ADD OwnerSplitState NVARCHAR(300);

UPDATE HousingMarket
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

-- Replacing Y and N with Yes and No within Sold as vacant column 

SELECT 
      DISTINCT(SoldAsVacant),COUNT(SoldAsVacant) AS Count
FROM HousingMarket
GROUP BY SoldAsVacant;

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant= 'Y' THEN 'Yes' 
      WHEN SoldAsVacant= 'N' THEN 'NO' 
      ELSE SoldAsVacant
	  END
FROM HousingMarket

UPDATE HousingMarket
SET SoldAsVacant = CASE WHEN SoldAsVacant= 'Y' THEN 'Yes' 
                        WHEN SoldAsVacant= 'N' THEN 'NO' 
                        ELSE SoldAsVacant
	                    END

--Dropping the unused columns 

SELECT * 
FROM HousingMarket

ALTER TABLE HousingMarket 
DROP COLUMN PropertyAddress,
            SaleDate,
			OwnerAddress,
			TaxDistrict

