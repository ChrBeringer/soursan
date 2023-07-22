from sqlalchemy import create_engine, Column, Integer, String, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker

DATABASE_URI = 'sqlite:///mydatabase.db'  # Replace 'mydatabase.db' with the name of your SQLite database file

Base = declarative_base()
engine = create_engine(DATABASE_URI)
Session = sessionmaker(bind=engine)


class DocumentType(Base):
    __tablename__ = 'documenttype'
    doctype_id = Column(Integer, primary_key=True)
    doctype_name = Column(String(30), nullable=False)
    description = Column(String(150))


class PlaceOfOrigin(Base):
    __tablename__ = 'place_of_origin'
    idplave_of_origin = Column(Integer, primary_key=True)
    City = Column(String(50))
    Institution = Column(String(50))
    Street = Column(String(50))
    Number = Column(String(5))
    Postcode = Column(Integer)


class Subject(Base):
    __tablename__ = 'subjects'
    subject_id = Column(Integer, primary_key=True)
    prename = Column(String(30), nullable=False)
    lastname = Column(String(30))
    date_of_birth = Column(Date)
    role = Column(String(150))
    gender = Column(String(10))


class Circle(Base):
    __tablename__ = 'circle'
    idcircle = Column(Integer, primary_key=True)
    subjects_subject_id = Column(Integer, ForeignKey('subjects.subject_id'), nullable=False)
    name = Column(String(30), nullable=False)
    description = Column(String(250))
    subject = relationship('Subject', backref='circles')


class Document(Base):
    __tablename__ = 'documents'
    documentID = Column(Integer, primary_key=True)
    documenttype_doctype_id = Column(Integer, ForeignKey('documenttype.doctype_id'), nullable=False)
    subjects_subject_id = Column(Integer, ForeignKey('subjects.subject_id'), nullable=False)
    place_of_origin_idplave_of_origin = Column(Integer, ForeignKey('place_of_origin.idplave_of_origin'), nullable=False)
    documentname = Column(String(50), nullable=False)
    summary = Column(String(255))
    date = Column(Date, nullable=False)
    path_to_file = Column(String(250), nullable=False)
    length_of_text = Column(Integer)
    subjective_length = Column(Integer)


class MainTopic(Base):
    __tablename__ = 'maintopic'
    id = Column(Integer, primary_key=True)
    documents_documenttype_doctype_id = Column(Integer, nullable=False)
    documents_documentID = Column(Integer, nullable=False)
    documents_subjects_subject_id = Column(Integer, nullable=False)
    shortname = Column(String(50))
    description = Column(String(500))


class DocumentHasAdressat(Base):
    __tablename__ = 'documents_has_adressat'
    documents_subjects_subject_id = Column(Integer, nullable=False)
    documents_documenttype_doctype_id = Column(Integer, nullable=False)
    documents_documentID = Column(Integer, nullable=False)
    subjects_subject_id = Column(Integer, ForeignKey('subjects.subject_id'), nullable=False, primary_key=True)


def create_tables():
    Base.metadata.create_all(engine)


def insert_document_type(doctype_name, description=None):
    with Session() as session:
        new_doc_type = DocumentType(doctype_name=doctype_name, description=description)
        session.add(new_doc_type)
        session.commit()


def insert_place_of_origin(city, institution, street, number, postcode):
    with Session() as session:
        new_place_of_origin = PlaceOfOrigin(City=city, Institution=institution, Street=street, Number=number, Postcode=postcode)
        session.add(new_place_of_origin)
        session.commit()


def insert_subject(prename, lastname=None, date_of_birth=None, role=None, gender=None):
    with Session() as session:
        new_subject = Subject(prename=prename, lastname=lastname, date_of_birth=date_of_birth, role=role, gender=gender)
        session.add(new_subject)
        session.commit()


# Implement similar functions for the rest of the tables (Circle, Document, MainTopic, DocumentHasAdressat)

if __name__ == "__main__":
    create_tables()

    # Example usage:
    insert_document_type(doctype_name="Report", description="A report document")
    insert_place_of_origin(city="New York", institution="University of XYZ", street="Main Street", number="123",
                           postcode=10001)
    insert_subject(prename="John", lastname="Doe", date_of_birth="1990-01-01", role="Researcher", gender="Male")
    # Continue with other data insertion functions for remaining tables.
