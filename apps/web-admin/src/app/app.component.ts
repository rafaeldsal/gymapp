import { Component } from '@angular/core';
import { ApiService } from './services/api.service';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  template: `
    <div style="padding: 20px; font-family: Arial, sans-serif;">
      <h1>GymApp - Web Admin</h1>
      <p>Status do Sistema:</p>
      
      <button (click)="testHealth()" style="margin: 5px; padding: 10px;">
        Testar Health Check
      </button>
      
      <button (click)="testStudents()" style="margin: 5px; padding: 10px;">
        Testar Students API
      </button>
      
      <div *ngIf="apiResponse" style="margin-top: 20px; padding: 10px; background: #f5f5f5; border-radius: 5px;">
        <strong>Resposta da API:</strong> {{ apiResponse }}
      </div>
      
      <div *ngIf="apiError" style="margin-top: 20px; padding: 10px; background: #ffe6e6; border-radius: 5px; color: red;">
        <strong>Erro:</strong> {{ apiError }}
      </div>
      
      <router-outlet />
    </div>
  `
})
export class AppComponent {
  apiResponse: string = '';
  apiError: string = '';

  constructor(private apiService: ApiService) { }

  testHealth() {
    this.apiResponse = 'Testando...';
    this.apiError = '';

    this.apiService.getHealth().subscribe({
      next: (response) => {
        this.apiResponse = response;
      },
      error: (error) => {
        this.apiError = 'Erro ao conectar com a API: ' + error.message;
      }
    });
  }

  testStudents() {
    this.apiResponse = 'Testando students...';
    this.apiError = '';

    this.apiService.testStudents().subscribe({
      next: (response) => {
        this.apiResponse = response;
      },
      error: (error) => {
        this.apiError = 'Erro ao conectar com Students API: ' + error.message;
      }
    });
  }
}