package com.example.avanceraddatabas.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.avanceraddatabas.model.Product;
import com.example.avanceraddatabas.repository.ProductRepository;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductRepository productRepository;

    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping(value = "", produces = "application/json")
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
}
