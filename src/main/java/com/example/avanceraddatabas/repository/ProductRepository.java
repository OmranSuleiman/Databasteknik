package com.example.avanceraddatabas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.avanceraddatabas.model.Product;

public interface ProductRepository extends JpaRepository<Product, Integer> {
}
