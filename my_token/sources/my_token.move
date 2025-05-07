module my_token::basic_nft;
    use sui::url::{Self, Url};
    use std::string::String;

    public struct NFT has key, store { 
        id: UID,
        name: String,
        description: String,
        image_url: Url,
        count: u64,
        creator: address,
    }
    
    // Create NFT(s) (allows minting multiple NFTs at once)
    public entry fun mint(
        name: String, 
        description: String, 
        image_url: vector<u8>,
        count: u64, 
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let url = url::new_unsafe_from_bytes(image_url);

        let mut i = 0;
        while (i < count) {
        let nft = NFT {
            id: object::new(ctx),
            name, 
            description, 
            image_url: url, 
            count: i,
            creator: sender,
        };
        transfer::public_transfer(nft, sender);
        i = i + 1;
        }
    }

    // Transfer NFT(s)
    public entry fun transfer_nft(nft: NFT, recipient: address, _: &mut TxContext) {
        transfer::public_transfer(nft, recipient);
    }

    // Remove NFT(s) from circulation
    public entry fun burn(nft: NFT, _: &mut TxContext) {
        transfer::public_transfer(nft, @0x0);
    }