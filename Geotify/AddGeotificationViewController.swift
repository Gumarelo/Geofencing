//
//  AddGeotificationViewController.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//
//  Esta clase deja al usuario crear nuevas geotificaciones
//  UUID stands for Uniquely Universal Identifier. A UUID is often represented in 32 hexadecimal characters; for example: 8753A44-4D6F-1226-9C60-0050E4C00067. The NSUUID class provides a convenient means to generate random UUID strings, which you can use to uniquely identify your objects.

import UIKit
import MapKit

protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String, eventType: EventType)
}

class AddGeotificationViewController: UITableViewController {

  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!

  @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var radiusTextField: UITextField!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!

  var delegate: AddGeotificationsViewControllerDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItems = [addButton, zoomButton]
    addButton.enabled = false

    tableView.tableFooterView = UIView()
  }

  // Controlamos que radiusTextField y noteTextField no sean entradas vacias
  // Si se considera que ambas entradas son validas entonces habilitamos el boton de add geotificacion
  @IBAction func textFieldEditingChanged(sender: UITextField) {
    addButton.enabled = !radiusTextField.text.isEmpty && !noteTextField.text.isEmpty
  }

  @IBAction func onCancel(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  // Esta funcion es llamada cuando el usuario pulsa sobre Add Button
  // Ademas de obtener las coordenadas, el tipo de evento, el radio y el valor de la nota, el metodo tambien genera un UUID para el identificador usando la clase NSUUID
  // EL metodo pasa todos los valores al delegado de la clase (GeotificationViewController) el cual crea una nueva geotificacion basado en estos valores.
  // Luego el metodo agrega la geotificacion a la lista de geotificaciones así como tambien a la vista del mapa principal
  @IBAction private func onAdd(sender: AnyObject) {
    var coordinate = mapView.centerCoordinate
    var radius = (radiusTextField.text as NSString).doubleValue
    var identifier = NSUUID().UUIDString
    var note = noteTextField.text
    var eventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? EventType.OnEntry : EventType.OnExit
    delegate!.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
  }

  @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
    zoomToUserLocationInMapView(mapView)
  }
}
