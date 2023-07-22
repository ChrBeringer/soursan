CREATE TABLE documenttype (
  doctype_id INTEGER  NOT NULL,
  doctype_name VARCHAR(30)  NOT NULL,
  description VARCHAR(150),
  PRIMARY KEY(doctype_id)
) ENGINE=InnoDB;


CREATE TABLE place_of_origin (
  idplave_of_origin INTEGER  NOT NULL,
  City VARCHAR(50),
  Institution VARCHAR(50),
  Street VARCHAR(50),
  Number VARCHAR(5),
  Postcode INTEGER,
  PRIMARY KEY(idplave_of_origin)
) ENGINE=InnoDB;


CREATE TABLE subjects (
  subject_id INTEGER  NOT NULL,
  prename VARCHAR(30)  NOT NULL,
  lastname VARCHAR(30),
  date_of_birth DATE,
  role VARCHAR(150),
  gender VARCHAR(10),
  PRIMARY KEY(subject_id)
) ENGINE=InnoDB;


CREATE TABLE circle (
  idcircle INTEGER  NOT NULL,
  subjects_subject_id INTEGER  NOT NULL,
  name VARCHAR(30)  NOT NULL,
  description VARCHAR(250),
  PRIMARY KEY(idcircle, subjects_subject_id),
  FOREIGN KEY(subjects_subject_id)
    REFERENCES subjects(subject_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
) ENGINE=InnoDB;


CREATE INDEX circle_FKIndex1 ON circle (subjects_subject_id) USING InnoDB;


CREATE TABLE documents (
  documentID INTEGER  NOT NULL,
  documenttype_doctype_id INTEGER  NOT NULL,
  subjects_subject_id INTEGER  NOT NULL,
  place_of_origin_idplave_of_origin INTEGER  NOT NULL,
  documentname VARCHAR(50)  NOT NULL,
  summary VARCHAR(255) DEFAULT NULL,
  date DATE  NOT NULL,
  path_to_file VARCHAR(250)  NOT NULL,
  length_of_text INTEGER,
  subjective_length INTEGER,
  PRIMARY KEY(documentID, documenttype_doctype_id, subjects_subject_id, place_of_origin_idplave_of_origin),
  FOREIGN KEY(documenttype_doctype_id)
    REFERENCES documenttype(doctype_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(subjects_subject_id)
    REFERENCES subjects(subject_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(place_of_origin_idplave_of_origin)
    REFERENCES place_of_origin(idplave_of_origin)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
) ENGINE=InnoDB;


CREATE INDEX documents_FKIndex1 ON documents (subjects_subject_id) USING InnoDB;
CREATE INDEX documents_FKIndex2 ON documents (place_of_origin_idplave_of_origin) USING InnoDB;


CREATE TABLE maintopic (
  id INTEGER  NOT NULL,
  documents_documenttype_doctype_id INTEGER  NOT NULL,
  documents_documentID INTEGER  NOT NULL,
  documents_subjects_subject_id INTEGER  NOT NULL,
  shortname VARCHAR(50),
  description VARCHAR(500),
  PRIMARY KEY(id, documents_documenttype_doctype_id, documents_documentID, documents_subjects_subject_id),
  FOREIGN KEY(documents_documentID, documents_documenttype_doctype_id, documents_subjects_subject_id, place_of_origin_idplave_of_origin)
    REFERENCES documents(documentID, documenttype_doctype_id, subjects_subject_id, place_of_origin_idplave_of_origin)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
) ENGINE=InnoDB;


CREATE INDEX maintopic_FKIndex1 ON maintopic (documents_documentID, documents_documenttype_doctype_id, documents_subjects_subject_id) USING InnoDB;


CREATE TABLE documents_has_adressat (
  documents_subjects_subject_id INTEGER  NOT NULL,
  documents_documenttype_doctype_id INTEGER  NOT NULL,
  documents_documentID INTEGER  NOT NULL,
  subjects_subject_id INTEGER  NOT NULL,
  PRIMARY KEY(documents_subjects_subject_id, documents_documenttype_doctype_id, documents_documentID, subjects_subject_id),
  FOREIGN KEY(documents_documentID, documents_documenttype_doctype_id, documents_subjects_subject_id, place_of_origin_idplave_of_origin)
    REFERENCES documents(documentID, documenttype_doctype_id, subjects_subject_id, place_of_origin_idplave_of_origin)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(subjects_subject_id)
    REFERENCES subjects(subject_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
) ENGINE=InnoDB;


CREATE INDEX documents_has_subjects_FKIndex1 ON documents_has_adressat (documents_documentID, documents_documenttype_doctype_id, documents_subjects_subject_id) USING InnoDB;
CREATE INDEX documents_has_subjects_FKIndex2 ON documents_has_adressat (subjects_subject_id) USING InnoDB;
