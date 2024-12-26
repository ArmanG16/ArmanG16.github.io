use actix_files as fs;
use actix_web::{App, HttpServer};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(fs::Files::new("/", "./static").index_file("index.html")) // Main static folder
            .service(fs::Files::new("/images", "./static/images")) // Explicit image route
    })
    .bind("0.0.0.0:8080")? // Bind to all network interfaces
    .run()
    .await
}
