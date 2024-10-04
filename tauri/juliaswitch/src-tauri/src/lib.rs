use sessionless::hex::IntoHex;
use sessionless::{Sessionless};

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    let sessionless = Sessionless::new();
println!("foo");
    format!("Hello, {}! You've been greeted from Rust!", sessionless.private_key().to_hex())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
