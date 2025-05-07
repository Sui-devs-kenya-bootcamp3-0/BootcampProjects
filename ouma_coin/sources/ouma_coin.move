#[allow(unused_variable)]
module ouma_coin::ouma {
    use sui::coin::{Self, Coin, TreasuryCap};
    // use sui::transfer;
    // use sui::tx_context::{Self, TxContext};

    // Name of the coin. By convention, this type has the same name as its parent module
    // and has no fields. The full type of the coin defined by this module will be OUMA<OUMA>.
    public struct OUMA has drop {}

    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: OUMA, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<OUMA>(
            witness,
            8, // Decimals
            b"OUMA", // Name
            b"OUMA", // Symbol
            b"OUMA token on Sui blockchain", // Description
            option::none(), // Icon URL - optional
            ctx
        );
        
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new tokens
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<OUMA>, 
        amount: u64, 
        recipient: address, 
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn tokens
    public entry fun burn(
        treasury_cap: &mut TreasuryCap<OUMA>, 
        ouma: Coin<OUMA>
    ) {
        coin::burn(treasury_cap, ouma);
    }

    /// Allow users to transfer coins
    public entry fun transfer(
        ouma: Coin<OUMA>, 
        recipient: address,
        ctx: &mut TxContext
    ) {
        transfer::public_transfer(ouma, recipient)
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(_ctx: &mut TxContext) {
        init(OUMA {}, _ctx)
    }
}

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions
