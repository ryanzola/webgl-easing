import * as THREE from 'three'

import Experience from './Experience'

import vertex from './shaders/canvas/vertex.glsl'
import fragment from './shaders/canvas/fragment.glsl'

export default class Canvas
{
    constructor(_options)
    {
        this.experience = new Experience()
        this.scene = this.experience.scene
        this.renderer = this.experience.renderer.instance
        this.camera = this.experience.camera.instance
        this.config = this.experience.config
        this.time = this.experience.time

        this.setGeometry()
        this.setMaterial()
        this.setMesh()
        this.resize()
    }

    setGeometry() {
      this.geometry = new THREE.PlaneBufferGeometry(2, 2, 1, 1)
    }

    setMaterial() {
      this.material = new THREE.ShaderMaterial({
        vertexShader: vertex,
        fragmentShader: fragment,
        uniforms: {
          iResolution: { value: new THREE.Vector3() },
          iTime: { value: 0.0 }
        }
      })
    }

    setMesh() {
      this.mesh = new THREE.Mesh(this.geometry, this.material)
      this.scene.add(this.mesh)
    }

    resize() {
      
      this.material.uniforms.iResolution.value.x = this.config.width 
      this.material.uniforms.iResolution.value.y = this.config.height
      this.material.uniforms.iResolution.value.z = this.renderer.getPixelRatio()
      console.log(this.material.uniforms.iResolution.value)
    }

    update() {
      this.material.uniforms.iTime.value = this.time.elapsed * 0.0005;
    }
}