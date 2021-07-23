package org.tests.model.json;

import io.ebean.annotation.DbJson;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Version;

@Entity
public class EBasicPlain {

  @Id
  long id;

  String attr;

  @DbJson(length = 500)
  PlainBean plainBean;

  @Version
  long version;

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public String getAttr() {
    return attr;
  }

  public void setAttr(String attr) {
    this.attr = attr;
  }

  public PlainBean getPlainBean() {
    return plainBean;
  }

  public void setPlainBean(PlainBean plainBean) {
    this.plainBean = plainBean;
  }

  public long getVersion() {
    return version;
  }

  public void setVersion(long version) {
    this.version = version;
  }
}