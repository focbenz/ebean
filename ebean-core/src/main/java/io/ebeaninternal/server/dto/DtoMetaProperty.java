package io.ebeaninternal.server.dto;

import io.ebean.core.type.DataReader;
import io.ebean.core.type.ScalarType;
import io.ebeaninternal.server.type.TypeManager;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Method;
import java.sql.SQLException;

final class DtoMetaProperty implements DtoReadSet {

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  private final Class<?> dtoType;
  private final String name;
  private final MethodHandle setter;
  private final ScalarType<?> scalarType;

  DtoMetaProperty(TypeManager typeManager, Class<?> dtoType, Method writeMethod, String name, Class<?> propertyType) throws IllegalAccessException, NoSuchMethodException {
    this.dtoType = dtoType;
    this.name = name;
    if (writeMethod != null) {
      this.setter = LOOKUP.findVirtual(dtoType, writeMethod.getName(), MethodType.methodType(void.class, propertyType));
      this.scalarType = typeManager.getScalarType(propertyType);
    } else {
      this.scalarType = null;
      this.setter = null;
    }
  }

  String getName() {
    return name;
  }

  @Override
  public boolean isReadOnly() {
    return scalarType == null;
  }

  @Override
  public void readSet(Object bean, DataReader dataReader) throws SQLException {
    Object value = scalarType.read(dataReader);
    invoke(bean, value);
  }

  private void invoke(Object instance, Object arg) {
    try {
      setter.invoke(instance, arg);
    } catch (Throwable e) {
      throw new RuntimeException("Error calling setter for property " + fullName() + " with arg: " + arg, e);
    }
  }

  private String fullName() {
    return dtoType.getName() + "." + name;
  }

}
