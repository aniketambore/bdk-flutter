use std::collections::HashMap;
use std::sync::Arc;
use bdk::bitcoin;
use bdk::blockchain::AnyBlockchain;
use crate::ffi::{Balance, Wallet};
use serde::{Deserialize, Serialize};

#[derive(Clone)]
pub(crate) struct  BdkInfo{
    pub wallet: Option<Arc<Wallet>>,
    pub blockchain: Option<Arc<AnyBlockchain>>,
    pub sbts:HashMap<String, bitcoin::blockdata::transaction::Transaction>,
}

#[derive(Serialize, Deserialize)]
pub struct ResponseWallet {
    pub balance: Balance,
    pub address: String,
}
#[repr(C)]
pub struct ExtendedKeyInfo {
    pub xprv: String,
    pub xpub: String,
    // pub fingerprint:String
}
#[repr(C)]
pub struct DerivedKeyInfo {
    pub xprv: String,
    pub xpub:String
}
pub struct ElectrumConfig {
    pub url: String,
    pub socks5: Option<String>,
    pub retry: u8,
    pub timeout: Option<u8>,
    pub stop_gap: u64,
}

pub struct EsploraConfig {
    pub base_url: String,
    pub proxy: Option<String>,
    pub concurrency: Option<u8>,
    pub stop_gap: u64,
    pub timeout: Option<u64>,
}

pub enum BlockchainConfig {
    ELECTRUM { config: ElectrumConfig },
    ESPLORA { config: EsploraConfig },
}

pub struct SqliteConfiguration {
    pub path: String,
}
pub enum DatabaseConfig {
    MEMORY,
    SQLITE { config: SqliteConfiguration },
}
pub enum KeyChainKind {
    EXTERNAL,
    INTERNAL,
}
#[derive(Clone)]
pub enum Network {
    TESTNET,
    REGTEST,
    BITCOIN,
    SIGNET
}
pub enum WordCount {
    WORDS12,
    WORDS18,
    WORDS24,
}
pub enum Entropy {
    ENTROPY128,
    ENTROPY192,
    ENTROPY256,
}

// pub enum BdkError {
//     BadWordCount,
//     UnknownWord,
//     BadEntropyBitCount,
//     InvalidChecksum,
//     // InvalidU32Bytes(Vec<u8>),
//     // Generic(String),
//     // ScriptDoesntHaveAddressForm,
//     // NoRecipients,
//     // NoUtxosSelected,
//     // OutputBelowDustLimit(usize),
//     // InsufficientFunds {
//     //     needed: u64,
//     //     available: u64,
//     // },
//     // BnBTotalTriesExceeded,
//     // BnBNoExactMatch,
//     // UnknownUtxo,
//     // TransactionNotFound,
//     // TransactionConfirmed,
//     // IrreplaceableTransaction,
//     // FeeRateTooLow {
//     //     required: FeeRate,
//     // },
//     // FeeTooLow {
//     //     required: u64,
//     // },
//     // FeeRateUnavailable,
//     // MissingKeyOrigin(String),
//     // Key(KeyError),
//     // ChecksumMismatch,
//     // SpendingPolicyRequired(KeychainKind),
//     // InvalidPolicyPathError(PolicyError),
//     // Signer(SignerError),
//     // InvalidNetwork {
//     //     requested: Network,
//     //     found: Network,
//     // },
//     // Verification(VerifyError),
//     // InvalidProgressValue(f32),
//     // ProgressUpdateError,
//     // InvalidOutpoint(OutPoint),
//     // Descriptor(Error),
//     // AddressValidator(AddressValidatorError),
//     // Encode(Error),
//     // Miniscript(Error),
//     // Bip32(Error),
//     // Secp256k1(Error),
//     // Json(Error),
//     // Hex(Error),
//     // Psbt(Error),
//     // PsbtParse(PsbtParseError),
//     // MissingCachedScripts(MissingCachedScripts),
//     // Electrum(Error),
//     // Esplora(Box<EsploraError>),
//     // CompactFilters(CompactFiltersError),
//     // Sled(Error),
//     // Rpc(Error),
//     // Rusqlite(Error),
// }