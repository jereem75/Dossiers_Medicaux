import random
import requests
from flask import Flask, render_template, request, redirect, url_for, session
import db
from passlib.context import CryptContext

##login='02921401965'

password_ctx = CryptContext(schemes=['bcrypt'])

app = Flask(__name__)

app.secret_key = b'd2b01c987b6f7f0d5896aae06c4f318c9772d6651abff24aec19297cdf5eb199'

@app.route("/connexion")
def connexion():
    return(render_template("connexion.html"))


@app.route("/verification",methods = ["post"])
def verification():
    identifiant=request.form.get('id',None)
    mdp=request.form.get('mdp',None)
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute('Select idpro from medecin')
            idp = cur.fetchall()
    for valeur in idp:
        if identifiant==valeur[0]:
            with db.connect() as conn:
                with conn.cursor() as cur2:
                    cur2.execute(f'select mdp from medecin where idpro=\'{identifiant}\'')
                    password=cur2.fetchone()
            if(password_ctx.verify(mdp,password[0]))==True:
                session["id"]=identifiant
                return(redirect(url_for("lstpatients")))
    return(redirect(url_for("connexion")))

   

@app.route("/lstpatients")
def lstpatients():
    if "patient" in session:
        session.pop("patient")
    if "id" not in session:
        return (redirect(url_for("connexion")))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute(f'Select distinct numsecu,nom,prenom from Dossier natural join est_admis natural join service_hopital natural join travaille where idpro=\'{session["id"]}\'')
            result = cur.fetchall()
        with conn.cursor() as cur2:
            cur2.execute(f'Select nom,prenom from medecin where idpro=\'{session["id"]}\'')
            result2 = cur2.fetchall()
    return(render_template("accueil.html",lst=result,val=session["id"],lst2=result2))


@app.route("/deconnexion")
def deconnexion():
    if "id" in session:
        session.pop("id")
    return redirect(url_for("connexion"))


@app.route("/patient/<int:numsecu>")
def patient(numsecu):
    if "patient" not in session:
        session["patient"] = numsecu
    if "id" not in session:
        return (redirect(url_for("connexion")))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from dossier where numsecu = %s", (str(numsecu),))
            info = cur.fetchall()
        with conn.cursor() as cur2:
            cur2.execute("select actemedical.idacte,resumé,date_acte,heure, idfichier, nom from actemedical full join fichier on actemedical.idacte=fichier.idacte where numsecu=%s",(str(numsecu),))
            intervention=cur2.fetchall()
    return render_template("patient.html", info= info,intervention=intervention)


@app.route("/add/<int:numsecu>")
def add(numsecu):
    if "id" not in session:
        return (redirect(url_for("connexion")))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from dossier where numsecu = %s", (str(numsecu),))
            info = cur.fetchall()
    return render_template("ajout.html",info=info)


@app.route("/add/register",methods = ["post"])
def register():
    add_id=request.form.get("idacte")
    add_resume=request.form.get("resume")
    add_date=request.form.get("date")
    add_heure=request.form.get("heure")
    numsecu=session["patient"]
    if not add_id or not add_resume or not add_date or not add_heure:
        return redirect(url_for("add",numsecu=numsecu))
    with db.connect() as conn:
        with conn.cursor() as cur1:
            cur1.execute("select idacte from actemedical")
            idacte=cur1.fetchall()
    for i in range (len(idacte)):
        if idacte[i][0]==add_id:
            return redirect(url_for("add",numsecu=numsecu))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into actemedical values (%s,%s,%s,%s,%s)",(add_id,add_resume,add_date,add_heure,numsecu))
    return redirect(url_for("patient",numsecu=numsecu))


@app.route("/modifier/<int:numsecu>")
def modifier(numsecu):
    if "id" not in session:
        return (redirect(url_for("connexxion")))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from dossier where numsecu = %s", (str(numsecu),))
            info = cur.fetchall()
    return render_template("modifier.html",info=info)

@app.route("/modifier/modif",methods = ["post"])
def modif():
    lst =[]
    modif_nom=request.form.get("nom",None)
    lst.append(modif_nom)
    modif_prenom=request.form.get("prenom",None)
    lst.append(modif_prenom)
    modif_adresse=request.form.get("adresse", None)
    lst.append(modif_adresse)
    modif_traitant=request.form.get("idtraitant", None)
    lst.append(modif_traitant)
    numsecu=session["patient"]
    with db.connect() as conn:
        for i in range (3):
            if lst[i]!="":
                if i == 0:
                    with conn.cursor() as cur:
                        cur.execute("update dossier set nom=(%s) where numsecu=(%s)",(modif_nom,str(numsecu)))
                if i == 1:
                    with conn.cursor() as cur2:
                        cur2.execute("update dossier set prenom=(%s) where numsecu=(%s)",(modif_prenom,str(numsecu)))   
                if i == 2:
                    with conn.cursor() as cur3:
                        cur3.execute("update dossier set adresse=(%s) where numsecu=(%s)",(modif_adresse,str(numsecu)))
                if i == 3:
                    with conn.cursor() as cur4:
                        cur4.execute("update dossier set idtraitant=(%s) where numsecu=(%s)",(modif_traitant,str(numsecu)))
    return redirect(url_for("patient",numsecu=numsecu))


if __name__ == '__main__':
    app.run(debug=True) 