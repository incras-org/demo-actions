package com.mirriad.trial.repository.entity

import org.hibernate.annotations.Type
import java.util.*
import javax.persistence.*

@Entity
class Product(
        @Id
        @Type(type = "uuid-char")
        val id: UUID?,
        val name: String)