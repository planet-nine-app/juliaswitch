use julia_rs::{Julia, JuliaUser};
use sessionless::hex::IntoHex;
use sessionless::{Sessionless};

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
async fn greet(name: &str) -> Result<String, String> {
    let sessionless = Sessionless::new();
println!("foo");
    let julia = Julia::new(Some("http://localhost:3000/".to_string()));
    let public_key = julia.sessionless.public_key().to_hex();
    let handle = "handle1".to_string();
    let julia_user = JuliaUser::new(public_key, handle);
    let result = julia.create_user(julia_user).await;

    match result {
      Ok(user) => {
          Ok(format!("hello, {}! You've been greeted from Rust!", user.uuid))
      },
      Err(error) => {
	Ok("ERROR".to_string())
      }
    }
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
