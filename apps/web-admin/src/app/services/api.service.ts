import { Injectable } from "@angular/core";
import { HttpClient } from '@angular/common/http';
import { Observable } from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'http://localhost:8080/ws-gymapp';

  constructor(private http: HttpClient) { }

  getHealth() {
    return this.http.get(`${this.apiUrl}/health`, { responseType: 'text' });
  }

  testStudents(): Observable<string> {
    return this.http.get(`${this.apiUrl}/api/students/test`, { responseType: 'text' });
  }
}