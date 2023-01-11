package com.mirriad.trial.api.controller

import io.swagger.annotations.Api
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class ProductController @Autowired constructor() {

    @GetMapping("/ping")
    fun ping(): String {
        return "pong"
    }
}

