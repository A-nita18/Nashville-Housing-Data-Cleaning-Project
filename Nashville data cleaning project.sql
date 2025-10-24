-- Cleaning table
USE nashvillehousingproject;

SELECT *
FROM nashvillehousing;

-- Standardize date
SELECT SaleDate, str_to_date(SaleDate, '%M %d, %Y')
FROM nashvillehousing;

UPDATE nashvillehousing
SET SaleDate = str_to_date(SaleDate, '%M %d, %Y');

-- Populating property address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE nashvillehousing a
JOIN nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Splitting up the property address
SELECT PropertyAddress, substring_index(PropertyAddress, ",", 1), substring_index(PropertyAddress, ", ", -1)
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD PropertySplitAddress varchar(255);

UPDATE nashvillehousing
SET PropertySplitAddress = substring_index(PropertyAddress, ",", 1);

ALTER TABLE nashvillehousing
ADD PropertySplitCity varchar(255);

UPDATE nashvillehousing
SET PropertySplitCity = substring_index(PropertyAddress, ", ", -1);

-- Splitting up Owner address
SELECT 
	OwnerAddress, 
    substring_index(OwnerAddress, ",", 1),
    substring_index((substring_index(OwnerAddress, ", ", -2)), ", ", 1),
    substring_index(OwnerAddress, ", ", -1)
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD OwnerSplitAddress varchar(255);

UPDATE nashvillehousing
SET OwnerSplitAddress = substring_index(OwnerAddress, ",", 1);

ALTER TABLE nashvillehousing
ADD OwnerSplitCity varchar(255);

UPDATE nashvillehousing
SET OwnerSplitCity = substring_index((substring_index(OwnerAddress, ", ", -2)), ", ", 1);

ALTER TABLE nashvillehousing
ADD OwnerSplitState varchar(255);

UPDATE nashvillehousing
SET OwnerSplitState = substring_index(OwnerAddress, ", ", -1);

-- Changing Y and N to Yes and No in sold as vacant
SELECT DISTINCT SoldAsVacant, Count(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END
FROM nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;


-- Remove Duplicates
WITH RowNumCTE AS
(
SELECT *,
	ROW_NUMBER() OVER(
    PARTITION BY ParcelID,
				 PropertyAddress,
                 SaleDate,
                 LegalReference,
                 SalePrice
	ORDER BY UniqueID) as row_num
FROM nashvillehousing
)
DELETE a
FROM nashvillehousing a
JOIN RowNumCTE b
	USING(UniqueID)
WHERE row_num > 1;

-- Removing unused columns
SELECT *
FROM nashvillehousing;

ALTER TABLE nashvillehousing
DROP COLUMN PropertyAddress, 
DROP COLUMN OwnerAddress;