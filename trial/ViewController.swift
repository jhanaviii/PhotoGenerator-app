//
//  ViewController.swift
//  trial
//
//  Created by Jhanavi Agarwal on 23/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Random Photo", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        // Add the imageView and button to the view hierarchy
        view.addSubview(imageView)
        view.addSubview(button)
        
        // Set up constraints for imageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Set up constraints for button
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50), // Shifted down by 50 points
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add action to button
        button.addTarget(self, action: #selector(loadRandomPhoto), for: .touchUpInside)
    }
    
    @objc func loadRandomPhoto() {
        let urlString = "https://picsum.photos/300"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response object")
                return
            }
            
            print("HTTP Response status code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Server error with status code: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            print("Data received: \(data.count) bytes")
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    print("Image successfully created from data")
                    self?.imageView.image = image
                } else {
                    print("Failed to create image from data")
                }
                self?.changeBackgroundColor()
            }
        }
        
        task.resume()
    }
    
    func changeBackgroundColor() {
        let colors: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemOrange, .systemPurple, .systemYellow, .systemTeal]
        view.backgroundColor = colors.randomElement()
    }
}
