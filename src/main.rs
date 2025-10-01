use std::env;
use actix_files as fs;
use actix_web::{App, HttpServer};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Read Render's PORT, default to 8080 when running locally
    let port: u16 = env::var("PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse()
        .expect("PORT must be a number");

    HttpServer::new(|| {
        App::new()
            // serve ./static as the site root (index.html at /)
            .service(fs::Files::new("/", "./static").index_file("index.html"))
            // explicit images route (optional if already under ./static/images)
            .service(fs::Files::new("/images", "./static/images"))
    })
    .bind(("0.0.0.0", port))?   // bind to all interfaces and the Render port
    .run()
    .await
}
