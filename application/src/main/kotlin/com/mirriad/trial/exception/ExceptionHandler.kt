package com.mirriad.trial.exception

import brave.Tracer
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler

@ControllerAdvice
class ExceptionHandler {

    @Autowired
    private lateinit var tracer: Tracer

    private val logger = LoggerFactory.getLogger(this::class.java)

    @ExceptionHandler(NoSuchElementException::class)
    fun handleNoSuchElementException(e: NoSuchElementException): ResponseEntity<ErrorMessage> {
        logger.warn(e.message, e)
        return ResponseEntity(ErrorMessage(
            e.message,
            HttpStatus.NOT_FOUND.value(),
            tracer.currentSpan().context().spanIdString()
        ), HttpStatus.NOT_FOUND)
    }

}