// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract BlogPay {
    address public owner;

    struct Record { 
        uint256 id;
        string webLink;
        uint256 totalNumber;
        string title;
        bool available;
    }

    struct Post {
        uint256 id;
        string title;
        string subheader;
        bool available;
        string text;
        uint256[] fileRecords;
    }

    constructor() {
        owner=msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    mapping(uint256=>Record) public records;
    uint256 public recordAmount;
    mapping(uint256=>Post) public posts;
    uint256 public postAmount;
    uint256 public postOffAmount;
    uint256 public recordOffAmount;

    function transferOwnerShip(address _newAddress) public onlyOwner validAddress(_newAddress) {
        owner=_newAddress;
    }

    function deAvailableAPost(uint256 _id) public onlyOwner {
        require(_id<postAmount,"");
        Post storage post = posts[_id];
        post.available=false;
        postOffAmount++;
    }

    function getPosts() public view returns (Post[] memory) {
        Post[] memory allPost = new Post[](postAmount-postOffAmount);
        uint256 e = 0;
        for (uint g = 0; g < postAmount;g++) {
            if (posts[g].available==true) {
                allPost[e]=posts[g];
                if (allPost.length==postAmount-postOffAmount) {
                    break;
                }
                e+=1;
            }
        }
        return allPost;
    }

    function getRecords() public view returns (Record[] memory) {
        Record[] memory allRecord = new Record[](recordAmount-recordOffAmount);
        uint256 e=0;
        for (uint g= 0; g< recordAmount;g++) {
            if (records[g].available==true) {
                allRecord[e]=records[g];
                if (allRecord.length==recordAmount-recordOffAmount) {
                    break;
                }
                e+=1;
            }
        }
        return allRecord;
    }

    function getAllRecords() public view onlyOwner returns (Record[] memory) {
        Record[] memory allRecord = new Record[](recordAmount);
        for (uint g =0; g<recordAmount;g++) {
            allRecord[g]=records[g];
        }
        return allRecord;
    }

    function getAllPosts() public view onlyOwner returns (Post[] memory) {
        Post[] memory allPost = new Post[](postAmount);
        for (uint g =0; g<postAmount;g++) {
            allPost[g]=posts[g];
        }
        return allPost;
    }

    function getPost(uint256 _id) public view returns (Post memory) {
        Post memory post = posts[_id];
        require(post.available==true&&_id<postAmount,"");
        return post;
    }

    function getRecord(uint256 _id) public view returns (Record memory) {
        Record memory record = records[_id];
        require(record.available==true&&_id<recordAmount,"");
        return record;
    }

    function deAvailableARecord(uint256 _id) public onlyOwner {
        require(_id<recordAmount,"");
        Record storage record = records[_id];
        record.available=false;
        recordOffAmount++;
    }

    function createAPost(
        string memory _title,
        string memory _text,
        string memory _sub
    ) public onlyOwner returns (uint256) {
        Post storage post = posts[postAmount];
        post.id=postAmount;
        post.subheader=_sub;
        post.text=_text;
        post.title=_title;
        post.available=true;
        postAmount++;
        return postAmount-1;
    }

    function addRecordToPost(
        uint256[] memory _records,
        uint256 _id
    ) public {
        Post storage post = posts[_id];
        for (uint h=0; h<_records.length;h++) {
            post.fileRecords.push(h);
        }
    }

    function createARecord(
        string memory _webLink,
        string memory _title,
        uint256 _totalNumber
    ) public onlyOwner returns (uint256) {
        Record storage record = records[recordAmount];
        require(_totalNumber>0,"");
        record.webLink=_webLink;
        record.id=recordAmount;
        record.available=true;
        record.title=_title;
        record.totalNumber=_totalNumber;
        recordAmount++;
        return recordAmount-1;
    }
}