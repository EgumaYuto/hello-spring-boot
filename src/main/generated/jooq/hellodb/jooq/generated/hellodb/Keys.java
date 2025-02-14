/*
 * This file is generated by jOOQ.
 */
package jooq.generated.hellodb;


import jooq.generated.hellodb.tables.Users;
import jooq.generated.hellodb.tables.records.UsersRecord;

import org.jooq.TableField;
import org.jooq.UniqueKey;
import org.jooq.impl.DSL;
import org.jooq.impl.Internal;


/**
 * A class modelling foreign key relationships and constraints of tables in
 * hellodb.
 */
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class Keys {

    // -------------------------------------------------------------------------
    // UNIQUE and PRIMARY KEY definitions
    // -------------------------------------------------------------------------

    public static final UniqueKey<UsersRecord> KEY_USERS_EMAIL = Internal.createUniqueKey(Users.USERS, DSL.name("KEY_users_email"), new TableField[] { Users.USERS.EMAIL }, true);
    public static final UniqueKey<UsersRecord> KEY_USERS_PRIMARY = Internal.createUniqueKey(Users.USERS, DSL.name("KEY_users_PRIMARY"), new TableField[] { Users.USERS.ID }, true);
}
