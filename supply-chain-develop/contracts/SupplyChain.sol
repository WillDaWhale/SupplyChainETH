pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

// import "../contracts/Seriality.sol";


contract SupplyChain {
//===============================================================================//
//=================================Variables=====================================//
    struct supply {
        bool exist;
        bool used;
        string supplyName;
        string supplierName;
    }

    struct product {
        bool exist;
        string productName;
        string producerName;
        uint totalComponents;
        string[] ComponentIDs;
        string[] ComponentNames;
        string[] ComponentsProviders;
    }

    uint private totalSupplies;
    mapping(uint => string) public SuppliesIndex;
    mapping(string => SupplyChain.supply) public Supplies;

    uint private totalProducts;
    mapping(uint => string) public ProductsIndex;
    mapping(string => SupplyChain.product) public Products;

//===============================================================================//
//==================================Functions====================================//

    // Supplier functions
    function uploadSupply(string memory supplier, string memory _supplyName, string memory supplyID) public returns(string memory){
        require(!Supplies[supplyID].exist, "Component Already Exist!");

        Supplies[supplyID].supplyName = _supplyName;
        Supplies[supplyID].supplierName = supplier;

        Supplies[supplyID].exist = true;
        Supplies[supplyID].used = false;

        SuppliesIndex[totalSupplies] = supplyID;
        totalSupplies += 1;

        return Supplies[supplyID].supplyName;
    }

    // Producer functions
    function assignPart(string memory producer, string memory componentID, string memory _productName, string memory productID) public returns(string memory){
        //supply part needs to exist
        require(Supplies[componentID].exist, "Selected Component Does Not Exist!");

        //supply part is not previously assigned
        require(!Supplies[componentID].used, 'Selected Component is Already Assigned to Other Product!');

        if (!Products[productID].exist){
            Products[productID].exist = true;
            totalProducts += 1;
        }

        Products[productID].productName = _productName;
        Products[productID].producerName = producer;

        Products[productID].ComponentNames.push(Supplies[componentID].supplyName);
        Products[productID].ComponentsProviders.push(Supplies[componentID].supplierName);
        Products[productID].ComponentIDs.push(componentID);
        Products[productID].totalComponents += 1;

        Supplies[componentID].used = true;

        ProductsIndex[totalProducts] = productID;

        return Products[productID].productName;
    }

    // Custumer funtions
    function getProductInfo(string memory productID) public view returns(string memory PName, string memory PerName, uint N, string[] memory supplyIDs, string[] memory supplyNames, string[] memory supplierNames){
        require(Products[productID].exist, "Product Does Not Exist!");

        N = Products[productID].totalComponents;

        // supplyIDs = new string[](N);
        // supplyNames = new string[](N);
        // supplierNames = new string[](N);

        PName = Products[productID].productName;
        PerName = Products[productID].producerName;

        supplyIDs = Products[productID].ComponentIDs;
        supplyNames = Products[productID].ComponentNames;
        supplierNames = Products[productID].ComponentsProviders;

        return (PName, PerName, N, supplyIDs, supplyNames, supplierNames);
    }

    // Getters
    function getTotalSupply() public view returns(uint){
        return totalSupplies;
    }

    function getTotalProduct() public view returns(uint){
        return totalProducts;
    }

    function getTotalComponents(string memory productID) public view returns(uint){
        return Products[productID].totalComponents;
    }
    //
}