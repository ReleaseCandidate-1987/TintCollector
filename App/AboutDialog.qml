import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import "Controls"
import "Components"

/*!
    App.qml

    Hauptkomponente für die Darstellung von:
        - Header        🠒 Titel der Anwendung.
        - Footer        🠒 Statusleiste / Aufzählungen.
        - SideBar       🠒 Palettenübersicht.
        - ColorEditor   🠒 Hinzufügen / Editieren weiterer Farben.
        - MainItem      🠒 Darstellung der Farben.
*/
TintDialog {
    visible: true
    width: Math.min(1200, app.width * 0.8)
    height: Math.max(300, app.height * 0.8)
    title: `<span style="color: ${Theme.accent}; font-weight: 900;">TINT</span>COLLECTOR`

    standardButtons: DialogButtonBox.Ok
    onClosed: appSettings.showAboutDialogAtStart = false;

    extraContent: TintScrollView {
        id: scrollView
        clip: true
        implicitHeight: Math.min(__lbl.implicitHeight, app.height * 0.7)
        Layout.maximumHeight: app.height * 0.7

        contentWidth: availableWidth
        contentHeight: __lbl.implicitHeight
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        TintLabel {
            id: __lbl
            width: scrollView.availableWidth
            textFormat: Text.RichText
            wrapMode: Text.WordWrap

            text: `
            <h3 style="color: ${Theme.accent};">Willkommen bei TintCollector</h3>
            <p>
            TintCollector ist eine Anwendung zum Erstellen, Verwalten und Exportieren
            individueller Farbpaletten. Sie bietet die Möglichkeit, Farben für
            unterschiedliche Projekte zentral zu sammeln, übersichtlich zu
            organisieren und anschließend in einem geeigneten Format
            weiterzuverwenden.
            </p>
            <p>
            Die Grundidee besteht darin, eine persönliche Sammlung von Farbpaletten
            aufzubauen, auf die bei der Entwicklung neuer Projekte jederzeit
            zurückgegriffen werden kann. Anstatt Farbwerte wiederholt herauszusuchen
            oder an verschiedenen Stellen abzulegen, können sie innerhalb einer
            gemeinsamen Anwendung verwaltet werden.
            </p>
            <p>
            TintCollector ist ein privates, nicht kommerzielles Projekt, das
            ursprünglich für den Einsatz in eigenen Softwareprojekten entwickelt
            wurde. Die Anwendung orientiert sich daher an konkreten Anforderungen
            bei der Gestaltung und Entwicklung grafischer Benutzeroberflächen.
            </p>

            <h3 style="color: ${Theme.accent};">Paletten erstellen und verwalten</h3>
            <p>
            Den Mittelpunkt der Anwendung bilden individuell zusammenstellbare
            Farbpaletten. Jede Palette erhält einen eigenen Namen und kann
            unabhängig von anderen Paletten verwaltet werden.
            </p>
            <p>
            Neue Paletten können jederzeit hinzugefügt werden. Bereits vorhandene
            Paletten lassen sich umbenennen oder vollständig entfernen. Für eine
            bessere Übersicht stehen verschiedene Sortiermöglichkeiten zur
            Verfügung. Die Sortierung kann alphabetisch von A bis Z oder
            umgekehrt erfolgen. Alternativ können Paletten nach der Anzahl
            ihrer enthaltenen Farben aufsteigend oder absteigend angeordnet werden.
            </p>
            <p>
            Dadurch bleibt die Palettenübersicht auch bei einer größeren
            Sammlung übersichtlich und ermöglicht einen schnellen Zugriff
            auf die gewünschten Farbzusammenstellungen.
            </p>

            <h3 style="color: ${Theme.accent};">Farben und Kategorien</h3>
            <p>
            Innerhalb einer Palette können beliebige Farben mit einem eigenen
            Namen und Farbwert angelegt werden. Zur besseren Organisation
            werden die Farben in fünf festgelegte Kategorien unterteilt:
            </p>
            <ul>
            <li><b>Hintergründe:</b> Farben für Flächen und Hintergrundbereiche.</li>
            <li><b>Schriftfarben:</b> Farben für Texte und Beschriftungen.</li>
            <li><b>Rahmen:</b> Farben für Umrandungen und Trennlinien.</li>
            <li><b>Akzente:</b> Farben für Hervorhebungen und gestalterische Elemente.</li>
            <li><b>Signale:</b> Farben zur Darstellung bestimmter Zustände oder Hinweise.</li>
            </ul>
            <p>
            Jede angelegte Farbe kann nachträglich bearbeitet werden. Dazu gehört
            das Ändern des Farbwertes, das Umbenennen der Farbe sowie das Kopieren
            ihres Farbwertes in die Zwischenablage. Nicht mehr benötigte Farben
            können einzeln entfernt werden.
            </p>
            <p>
            Über Drag-and-Drop lassen sich Farben innerhalb einer Kategorie neu
            anordnen oder zwischen den verschiedenen Kategorien verschieben.
            Auf diese Weise kann die Struktur einer Palette jederzeit angepasst
            werden, ohne Farben erneut erstellen zu müssen.
            </p>
            <p>
            Zusätzlich steht eine Funktion zur Verfügung, mit der sämtliche
            Farben einer ausgewählten Palette auf einmal entfernt werden können.
            Die Palette selbst bleibt dabei erhalten.
            </p>
            <p>
            Jede Palette ist auf maximal <b>32 Farben</b> begrenzt. Diese
            Begrenzung ist bewusst gewählt, um übersichtliche und gezielt
            zusammengestellte Farbpaletten zu fördern. Statt möglichst viele
            Farben anzusammeln, steht eine sinnvolle Auswahl für den jeweiligen
            Verwendungszweck im Vordergrund.
            </p>

            <h3 style="color: ${Theme.accent};">Farbeditor und Farbgenerator</h3>
            <p>
            Der integrierte Farbeditor ermöglicht das Erstellen neuer Farben
            auf Grundlage einer frei wählbaren Basisfarbe. Aus dieser
            Basisfarbe können unterschiedliche Farbvariationen generiert
            werden, die anschließend in eine Palette übernommen werden können.
            </p>
            <p>
            Über eine Kategorieauswahl wird festgelegt, welcher der fünf
            Kategorien die generierten Farben zugeordnet werden sollen.
            Darüber hinaus stehen verschiedene Generierungsmodi zur Verfügung,
            darunter <b>Aufhellen</b>, <b>Abdunkeln</b> und <b>Sättigen</b>
            sowie weitere Möglichkeiten zur Veränderung der Basisfarbe.
            </p>
            <p>
            Die Anzahl der generierten Farben kann zwischen <b>1 und 6</b>
            festgelegt werden. Eine zusätzliche Einstellung bestimmt den
            Abstand zwischen den einzelnen Farbvariationen.
            </p>
            <p>
            Dieser Abstand beeinflusst, wie stark sich die Farben über die
            gesamte generierte Reihe hinweg verändern. Ein geringer Abstand
            erzeugt entsprechend kleinere Unterschiede zur Basisfarbe,
            während ein größerer Abstand deutlichere Abstufungen ermöglicht.
            </p>
            <p>
            Die Ergebnisse werden zunächst in einer Vorschau dargestellt.
            Von dort können einzelne Farben per Drag-and-Drop direkt in
            eine gewünschte Kategorie verschoben werden. Alternativ können
            alle generierten Farben über eine Schaltfläche gemeinsam
            übernommen werden.
            </p>
            <p>
            Der Farbgenerator soll insbesondere das Zusammenstellen
            aufeinander abgestimmter Farbabstufungen vereinfachen.
            Farbvariationen müssen dadurch nicht ausschließlich
            einzeln über einen Farbwähler erstellt werden.
            </p>

            <h3 style="color: ${Theme.accent};">Farbpaletten exportieren</h3>
            <p>
            Ein wesentlicher Bestandteil von TintCollector ist die Möglichkeit,
            zusammengestellte Farbpaletten in anderen Projekten
            weiterzuverwenden. Dafür steht eine Exportfunktion mit
            verschiedenen Ausgabeformaten zur Verfügung.
            </p>
            <ul>
            <li>
            <b>QML:</b> Exportiert die Farben zur Verwendung in
            Qt-Quick- und QML-Projekten.
            </li>
            <li>
            <b>CSS:</b> Stellt die Farben als CSS-Variablen bereit,
            beispielsweise für die Gestaltung von Weboberflächen.
            </li>
            <li>
            <b>Text:</b> Erstellt eine einfache und lesbare
            Auflistung der gespeicherten Farbwerte.
            </li>
            </ul>
            <p>
            Durch die unterschiedlichen Exportformate können Farbpaletten
            unabhängig vom ursprünglichen Projekt zusammengestellt
            und später in verschiedene Entwicklungsumgebungen übernommen
            werden. Insbesondere bei wiederkehrenden Gestaltungsaufgaben
            kann so auf bereits vorbereitete Farbkombinationen
            zurückgegriffen werden.
            </p>

            <h3 style="color: ${Theme.accent};">Suche und Benutzeroberfläche</h3>
            <p>
            Im oberen Bereich der Anwendung befindet sich ein Suchfeld,
            über das vorhandene Paletten schneller gefunden werden können.
            Ergänzend stehen die Sortierfunktionen innerhalb der
            Palettenübersicht zur Verfügung.
            </p>
            <p>
            Die Benutzeroberfläche unterstützt sowohl ein helles als auch
            ein dunkles Erscheinungsbild. Zwischen beiden Darstellungsmodi
            kann jederzeit gewechselt werden.
            </p>
            <p>
            Im unteren Bereich der Anwendung befindet sich eine Statusleiste.
            Diese zeigt die Gesamtanzahl der vorhandenen Paletten, die Anzahl
            aller gespeicherten Farben sowie den Namen der aktuell
            ausgewählten Palette an.
            </p>
            <p>
            Bei der Gestaltung der Benutzeroberfläche stehen eine klare
            Aufteilung der Funktionen und eine möglichst übersichtliche
            Verwaltung der Farbpaletten im Vordergrund.
            </p>

            <h3 style="color: ${Theme.accent};">Technische Umsetzung</h3>
            <p>
            TintCollector wurde mit <b>Qt 6.12</b> entwickelt.
            Die grafische Benutzeroberfläche basiert auf
            <b>Qt Quick und QML</b>. Die zugrunde liegende
            Anwendungslogik sowie die Verwaltung und Verarbeitung
            der Daten werden überwiegend in <b>C++</b> umgesetzt.
            </p>
            <p>
            Für die dauerhafte Speicherung der Paletten und Farben
            kommt eine <b>SQLite-Datenbank</b> zum Einsatz.
            In der Desktop-Version befindet sich diese lokal
            auf dem jeweiligen Computer.
            </p>

            <h3 style="color: ${Theme.accent};">WebAssembly-Vorschau</h3>
            <p>
            Bei der hier ausgeführten Anwendung handelt es sich um
            eine <b>WebAssembly-Version von TintCollector</b>.
            Sie ermöglicht es, die ursprünglich als Desktop-Anwendung
            entwickelte Software direkt im Webbrowser auszuführen,
            ohne eine zusätzliche Installation vornehmen zu müssen.
            </p>
            <p>
            Die WebAssembly-Version verwendet dieselbe grundlegende
            Anwendungsarchitektur mit Qt, QML und C++.
            Auch die Datenverwaltung erfolgt weiterhin über SQLite.
            </p>
            <p>
            Da ein Webbrowser keinen gewöhnlichen direkten Zugriff
            auf das lokale Dateisystem bereitstellt, wird die Datenbank
            innerhalb eines virtuellen Dateisystems verwendet.
            Die Speicherung erfolgt über <b>IndexedDB</b>,
            eine Speichertechnologie des Browsers.
            </p>
            <p>
            Änderungen an den Paletten und Farben werden dadurch
            lokal im jeweiligen Browser gespeichert. Es handelt sich
            nicht um eine zentrale Onlinedatenbank und es findet
            keine automatische Synchronisierung zwischen verschiedenen
            Browsern oder Geräten statt.
            </p>
            <p>
            Die gespeicherten Daten sind an das jeweilige Browserprofil
            und die aufgerufene Website gebunden. Beim Löschen der
            entsprechenden Browserdaten können daher auch die dort
            angelegten Paletten und Farben verloren gehen.
            </p>
            <p>
            Die WebAssembly-Version dient als direkt zugängliche
            Vorschau, um die Benutzeroberfläche und die vorhandenen
            Funktionen der Anwendung im Browser kennenzulernen
            und auszuprobieren.
            </p>

            <h3 style="color: ${Theme.accent};">Über den Entwickler</h3>
            <p>
            <b>Michael Saracen</b> ist Fachinformatiker mit der
            Fachrichtung Anwendungsentwicklung. Der Schwerpunkt
            seiner Arbeit und seiner persönlichen Projekte liegt
            auf der Entwicklung von Desktop-Anwendungen mit
            <b>C++, Qt und QML</b>.
            </p>
            <p>
            Dabei stehen sowohl die Umsetzung der Anwendungslogik
            als auch die Entwicklung grafischer Benutzeroberflächen
            im Mittelpunkt.
            </p>
            <p>
            TintCollector ist ein eigenständig entwickeltes,
            privates Softwareprojekt, das aus dem praktischen
            Bedarf heraus entstanden ist, Farbpaletten für
            weitere eigene Entwicklungsprojekte zentral
            zusammenzustellen und wiederverwenden zu können.
            </p>
            `
        }
    }
}
