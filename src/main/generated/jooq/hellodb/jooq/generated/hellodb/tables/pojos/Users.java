/*
 * This file is generated by jOOQ.
 */
package jooq.generated.hellodb.tables.pojos;


import java.io.Serializable;
import java.time.LocalDateTime;


/**
 * This class is generated by jOOQ.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;

    private final Long id;
    private final String name;
    private final String email;
    private final LocalDateTime createdAt;

    public Users(Users value) {
        this.id = value.id;
        this.name = value.name;
        this.email = value.email;
        this.createdAt = value.createdAt;
    }

    public Users(
        Long id,
        String name,
        String email,
        LocalDateTime createdAt
    ) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.createdAt = createdAt;
    }

    /**
     * Getter for <code>hellodb.users.id</code>.
     */
    public Long getId() {
        return this.id;
    }

    /**
     * Getter for <code>hellodb.users.name</code>.
     */
    public String getName() {
        return this.name;
    }

    /**
     * Getter for <code>hellodb.users.email</code>.
     */
    public String getEmail() {
        return this.email;
    }

    /**
     * Getter for <code>hellodb.users.created_at</code>.
     */
    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        final Users other = (Users) obj;
        if (this.id == null) {
            if (other.id != null)
                return false;
        }
        else if (!this.id.equals(other.id))
            return false;
        if (this.name == null) {
            if (other.name != null)
                return false;
        }
        else if (!this.name.equals(other.name))
            return false;
        if (this.email == null) {
            if (other.email != null)
                return false;
        }
        else if (!this.email.equals(other.email))
            return false;
        if (this.createdAt == null) {
            if (other.createdAt != null)
                return false;
        }
        else if (!this.createdAt.equals(other.createdAt))
            return false;
        return true;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((this.id == null) ? 0 : this.id.hashCode());
        result = prime * result + ((this.name == null) ? 0 : this.name.hashCode());
        result = prime * result + ((this.email == null) ? 0 : this.email.hashCode());
        result = prime * result + ((this.createdAt == null) ? 0 : this.createdAt.hashCode());
        return result;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Users (");

        sb.append(id);
        sb.append(", ").append(name);
        sb.append(", ").append(email);
        sb.append(", ").append(createdAt);

        sb.append(")");
        return sb.toString();
    }
}
